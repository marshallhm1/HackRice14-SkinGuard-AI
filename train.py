import os
import cv2
import numpy as np
import pandas as pd
from tqdm import tqdm
from glob import glob
from PIL import Image

import torch
from torch import optim, nn
from torch.utils.data import DataLoader, Dataset
from torchvision import models, transforms
from torch.autograd import Variable

from sklearn.model_selection import train_test_split

# Set random seeds for reproducibility
np.random.seed(10)
torch.manual_seed(10)

device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")

def compute_img_mean_std(image_paths):
    """Compute mean and std of image dataset"""
    img_h, img_w = 224, 224
    imgs = []
    for i in tqdm(range(len(image_paths))):
        img = cv2.imread(image_paths[i])
        img = cv2.resize(img, (img_h, img_w))
        imgs.append(img)
    imgs = np.stack(imgs, axis=3)
    imgs = imgs.astype(np.float32) / 255.
    means = np.mean(imgs, axis=(0, 1, 3))
    stds = np.std(imgs, axis=(0, 1, 3))
    return means, stds

class HAM10000(Dataset):
    def __init__(self, df, transform=None):
        self.df = df
        self.transform = transform

    def __len__(self):
        return len(self.df)

    def __getitem__(self, index):
        X = Image.open(self.df['path'].iloc[index])
        y = torch.tensor(int(self.df['cell_type_idx'].iloc[index]))

        if self.transform:
            X = self.transform(X)

        return X, y

def set_parameter_requires_grad(model, feature_extracting):
    if feature_extracting:
        for param in model.parameters():
            param.requires_grad = False

def initialize_model(model_name, num_classes, feature_extract, use_pretrained=True):
    model_ft = None
    input_size = 0

    if model_name == "densenet":
        model_ft = models.densenet121(pretrained=use_pretrained)
        set_parameter_requires_grad(model_ft, feature_extract)
        num_ftrs = model_ft.classifier.in_features
        model_ft.classifier = nn.Linear(num_ftrs, num_classes)
        input_size = 224

    return model_ft, input_size

class AverageMeter(object):
    def __init__(self):
        self.reset()

    def reset(self):
        self.val = 0
        self.avg = 0
        self.sum = 0
        self.count = 0

    def update(self, val, n=1):
        self.val = val
        self.sum += val * n
        self.count += n
        self.avg = self.sum / self.count

total_loss_train, total_acc_train = [],[]

def train(train_loader, model, criterion, optimizer, epoch, device):
    model.train()
    train_loss = AverageMeter()
    train_acc = AverageMeter()
    curr_iter = (epoch - 1) * len(train_loader)
    for i, data in enumerate(train_loader):
        images, labels = data
        N = images.size(0)
        images = images.to(device)
        labels = labels.to(device)

        optimizer.zero_grad()
        outputs = model(images)

        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        prediction = outputs.max(1, keepdim=True)[1]
        train_acc.update(prediction.eq(labels.view_as(prediction)).sum().item()/N)
        train_loss.update(loss.item())
        curr_iter += 1
        if (i + 1) % 100 == 0:
            print('[epoch %d], [iter %d / %d], [train loss %.5f], [train acc %.5f]' % (
                epoch, i + 1, len(train_loader), train_loss.avg, train_acc.avg))
            total_loss_train.append(train_loss.avg)
            total_acc_train.append(train_acc.avg)
    return train_loss.avg, train_acc.avg


def validate(val_loader, model, criterion, optimizer, epoch):
    model.eval()
    val_loss = AverageMeter()
    val_acc = AverageMeter()
    with torch.no_grad():
        for i, data in enumerate(val_loader):
            images, labels = data
            N = images.size(0)
            images = Variable(images).to(device)
            labels = Variable(labels).to(device)

            outputs = model(images)
            prediction = outputs.max(1, keepdim=True)[1]

            val_acc.update(prediction.eq(labels.view_as(prediction)).sum().item()/N)

            val_loss.update(criterion(outputs, labels).item())

    print('------------------------------------------------------------')
    print('[epoch %d], [val loss %.5f], [val acc %.5f]' % (epoch, val_loss.avg, val_acc.avg))
    print('------------------------------------------------------------')
    return val_loss.avg, val_acc.avg


def main():
    # Data preprocessing
    data_dir = '../input'
    all_image_path = glob(os.path.join(data_dir, '*', '*.jpg'))
    imageid_path_dict = {os.path.splitext(os.path.basename(x))[0]: x for x in all_image_path}
    lesion_type_dict = {
        'nv': 'Melanocytic nevi',
        'mel': 'dermatofibroma',
        'bkl': 'Benign keratosis-like lesions ',
        'bcc': 'Basal cell carcinoma',
        'akiec': 'Actinic keratoses',
        'vasc': 'Vascular lesions',
        'df': 'Dermatofibroma'
    }

    # Compute dataset statistics (only once)
    print("Computing dataset mean and std...")
    norm_mean, norm_std = compute_img_mean_std(all_image_path)
    print(f"Dataset mean: {norm_mean}, std: {norm_std}")

    # Prepare dataset
    df_original = pd.read_csv(os.path.join(data_dir, 'HAM10000_metadata.csv'))
    df_original['path'] = df_original['image_id'].map(imageid_path_dict.get)
    df_original['cell_type'] = df_original['dx'].map(lesion_type_dict.get)
    df_original['cell_type_idx'] = pd.Categorical(df_original['cell_type']).codes

    # Split data
    _, df_val = train_test_split(df_original, test_size=0.2, random_state=101, stratify=df_original['cell_type_idx'])
    df_train = df_original[~df_original['image_id'].isin(df_val['image_id'])]

    # Balance dataset
    data_aug_rate = [15,10,5,50,0,40,5]
    for i in range(7):
        if data_aug_rate[i]:
            df_to_repeat = df_train[df_train['cell_type_idx'] == i]
            df_repeated = pd.concat([df_to_repeat] * (data_aug_rate[i]-1), ignore_index=True)
            df_train = pd.concat([df_train, df_repeated], ignore_index=True)

    # Reset index
    df_train = df_train.reset_index(drop=True)
    df_val = df_val.reset_index(drop=True)

    # Define transforms
    train_transform = transforms.Compose([
        transforms.Resize((224,224)),
        transforms.RandomHorizontalFlip(),
        transforms.RandomVerticalFlip(),
        transforms.RandomRotation(20),
        transforms.ColorJitter(brightness=0.1, contrast=0.1, hue=0.1),
        transforms.ToTensor(),
        transforms.Normalize(norm_mean, norm_std)
    ])

    val_transform = transforms.Compose([
        transforms.Resize((224,224)),
        transforms.ToTensor(),
        transforms.Normalize(norm_mean, norm_std)
    ])

    # Optimized parameters
    BATCH_SIZE = 32
    NUM_WORKERS = 16  # 16 core gpu

    # Create data loaders
    train_set = HAM10000(df_train, transform=train_transform)
    train_loader = DataLoader(train_set, batch_size=BATCH_SIZE, shuffle=True, num_workers=NUM_WORKERS, pin_memory=True)

    val_set = HAM10000(df_val, transform=val_transform)
    val_loader = DataLoader(val_set, batch_size=BATCH_SIZE, shuffle=False, num_workers=NUM_WORKERS, pin_memory=True)

    # Initialize model
    model_name = 'densenet'
    num_classes = 7
    feature_extract = False
    model_ft, input_size = initialize_model(model_name, num_classes, feature_extract, use_pretrained=True)

    # Define device
    device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
    print(f"Using {device} device for training")

    model = model_ft.to(device)

    # Define optimizer and loss function
    optimizer = optim.Adam(model.parameters(), lr=1e-3)
    criterion = nn.CrossEntropyLoss().to(device)

    # Use mixed precision training only for CUDA
    use_amp = device.type == "cuda"
    scaler = torch.cuda.amp.GradScaler(enabled=use_amp)

    num_epochs = 10
    best_val_acc = 0

    for epoch in range(1, num_epochs + 1):
        print(f"Epoch {epoch}/{num_epochs}")
        train_loss, train_acc = train(train_loader, model, criterion, optimizer, epoch, device)
        val_loss, val_acc = validate(val_loader, model, criterion, optimizer, epoch)

        print(f"Train Loss: {train_loss:.4f}, Train Acc: {train_acc:.4f}")
        print(f"Val Loss: {val_loss:.4f}, Val Acc: {val_acc:.4f}")

        if val_acc > best_val_acc:
            best_val_acc = val_acc
            torch.save(model.state_dict(), 'v3.pth')
            print(f"New best model saved with validation accuracy: {val_acc:.4f}")

    print("Training completed!")

if __name__ == '__main__':
    main()