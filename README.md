Hello 👋

SkinGuard AI is our submission for HackRice14.

<img src="https://github.com/user-attachments/assets/a6f7e989-b8dd-4e15-98a6-6f3e258cc2de" alt="Home Page" width="242" height="520">
<img src="https://github.com/user-attachments/assets/22c6f66c-b378-4017-bba5-568df1ae6b1e" alt="Nearby Dermatologists" width="242" height="520">
<img src="https://github.com/user-attachments/assets/5c6808b5-6e75-4c75-8d2b-3b61a8c305fa" alt="Reports Page" width="242" height="520">
<img src="https://github.com/user-attachments/assets/b7dc4e91-02ff-45d7-9337-c2634106c6d6" alt="Image Upload" width="242" height="520">
<img src="https://github.com/user-attachments/assets/5467f9c1-086c-4f43-92a2-0343ed7a9afd" alt="Analysis Results" width="242" height="520">
<img src="https://github.com/user-attachments/assets/6df040e1-2ca3-4b03-9b7f-f39adce6650e" alt="Prevention and Support" width="242" height="520">



## Inspiration
Imagine a world where early detection of skin cancer is as easy as simply taking an image on your phone. This is the future we hope to make reality with SkinGuard AI. We were inspired to create this project due to the meteoric rise of Artificial Intelligence over the past few years. A lot of the discussion around AI centers on whether it will help or hurt humanity. We want to prove that AI can be used for good. One of the largest potential uses of AI is in the healthcare industry - not to replace doctors, but to help them. Skin cancer is a prime example of a discipline in which AI can help. Around 1 in 5 Americans will develop skin cancer by the age of 70. More people are diagnosed with skin cancer yearly than all other cancers combined. Melanoma, the most serious form of skin cancer has around a 99% 5-year survival rate, *when detected early*. Imagine if people who did not have the means to get their skin checked regularly were able to do this at home, through a mobile app. 

## What it does
Our app is an all-in-one resource for skin cancer prevention and detection. We implemented a deep learning model to detect many of the significant types of skin cancer as well as other pigmented skin lesions (a total of 7 different types). Users are able to record weekly check-ins and scans, as well as view nearby dermatologists, receive prevention tips, access to support groups, and even a journaling system. The app covers all bases, from detection, care, support, and resources, into one package with user-friendly interface design and ease of use.

## How we built it
We started by finding a dataset on Kaggle. We decided on using the HAM10000 ("Human Against Machine") dataset, which contains 10,000 different images of skin cancer and general lesions. We then used Python and PyTorch to create a deep learning model which utilizes DenseNet, a convolutional neural network that uses dense connections between layers, applicable to the classification of images. Once the model was trained, we converted it to CoreML, a framework used to integrate machine learning models into native iOS apps programmed in Swift. CoreML models run 100% locally using on device compute power. We created the app itself in SwiftUI, the best way to build apps on Apple platforms. SwiftUI excels in speed and design. We also used SwiftData, a lightweight API for persisting app data in Swift. We used SwiftData to store previously analyzed images, the model's response, the user's journal entries, and all other user generated content, 100% locally.

## Challenges we ran into
The biggest challenge over the course of this project was model training. Skin cancer lesions are inherently small, and oftentimes require multiple doctors or a biopsy to confirm a diagnosis. Operating on limited time, it was difficult to achieve good results over the large data set. Conversion to CoreML was also difficult, as we had no experience with converting models into Swift. However, we were able to achieve a **79% weighted precision score** over each 7 possible classifications. We were able to achieve these metrics and overcome this challenge by experimenting with the model as well as researching techniques for image classification.

## Accomplishments that we're proud of
We are proud of our 79% weighted precision score and we are very proud of our app design. We really focused a lot of time on making it an enjoyable experience for the user, while also being feature rich. We had a rough idea coming into the competition on Friday, and that idea evolved rapidly, and we were both very happy on how well the final product came out. The culmination of design, features, and technical rigor really impressed us, and we hope it impresses you too.

## What we learned
We learned that this idea was possible, and can be applied to other disciplines. We learned how to fine tune the model to crank out better results in a shorter timeframe, learned to leverage DenseNet features to better suit the data, and how to squeeze out more computing power from our laptops. We also learned how to convert models into CoreML, and how to integrate them with SwiftUI, taking raw output from the model and turning it into clear and concise output for the user. We also learned how to work as a duo effectively, bouncing ideas off of each other and showing each other prototype features, which led us both to realize we are much more effective working together rather than solo.

## What's next for SkinGuard AI
We believe that we can expand on this idea, and given more time to train the model, achieve results which are at or near the successful diagnosis rate given by doctors. We believe we could implement 3D mapping of skin irregularities in order to track changes in size and shape, comparing new images to previously uploaded images. We could also develop an algorithm that considers factors outside of just the image, such as age, skin type, and sun exposure to provide personalized risk assessment. We also think we could expand on dermatologist matching, focusing specifically on the type of lesion detected compared to the specialization of doctors. We believe this app could have potential in the future on the App Store, aiding in early detection of skin cancer, and potentially saving lives. 


