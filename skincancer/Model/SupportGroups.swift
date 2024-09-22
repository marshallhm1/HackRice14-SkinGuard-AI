import Foundation

struct SupportGroup {
    let name: String
    let description: String
    let image: String
    let website: String
}

let supportGroups: [SupportGroup] = [
    SupportGroup(
        name: "Cancer Support Community/Gilda’s Club",
        description: "Cancer Support Community provides a vast range of professional programs offering emotional support, education and hope for people impacted by cancer at no charge. Their services are online as well as 175 locations worldwide and include extensive educational materials in many languages.",
        image: "cancersupportcommunity",
        website: "https://www.cancersupportcommunity.org/"
    ),
    SupportGroup(
        name: "Cancer.net",
        description: "Cancer.net is a comprehensive compilation of linked resources approved by the American Society of Clinical Oncology (ASCO) to help manage the physical, emotional and social effects of cancer, including support groups and online communities.",
        image: "cancernet",
        website: "https://www.cancer.net/coping-with-cancer/finding-social-support-and-information"
    ),
    SupportGroup(
        name: "CURE",
        description: "CURE® Media Group’s flagship magazine and online resource curetoday.com provide access to leading resources and information that serve as a guide to every stage of the cancer experience.",
        image: "cure", 
        website: "https://www.curetoday.com/"
    ),
    SupportGroup(
        name: "SkinCancer.net",
        description: "Providing patients and caregivers with a platform to learn, educate and connect with peers and health care professionals, SkinCancer.net provides tools and resources to help manage your disease and improve your quality of life.",
        image: "skincancernet",
        website: "https://www.skincancer.net/"
    ),
    SupportGroup(
        name: "Smart Patients",
        description: "Smart Patients is an online community of support for patients and families.",
        image: "smartpatients",
        website: "https://www.smartpatients.com/home"
    ),
    SupportGroup(
        name: "SurvivorNet",
        description: "SurvivorNet collaborates with the top doctors and cancer centers in the U.S. to create medically reviewed content to help cancer patients, survivors and caregivers get accurate information, comfort and hope.",
        image: "survivornet",
        website: "https://www.survivornet.com/"
    ),
    SupportGroup(
        name: "First Descents",
        description: "First Descents provides life-changing outdoor adventures for young adults (ages 18 – 39) impacted by cancer and other serious health conditions.",
        image: "firstdescents",
        website: "https://firstdescents.org/"
    ),
    SupportGroup(
        name: "Stupid Cancer",
        description: "Stupid Cancer’s mission is to empower young adults (ages 15-39) affected by cancer by ending isolation and building community. Their website has a list of resources including many that provide financial assistance for young adults with a cancer diagnosis, meet-up group possibilities and an annual four day gathering called CancerCon®.",
        image: "stupidcancer",
        website: "https://stupidcancer.org/"
    ),
    SupportGroup(
        name: "LIVESTRONG at the YMCA",
        description: "LIVESTRONG assists those who are living with, through or beyond cancer to regain strength and connect with other cancer survivors. LIVESTRONG at the YMCA participants experience improved fitness and quality of life as well as significant decreases in cancer-related fatigue. It is open to adults 18 years or older at low or no cost.",
        image: "livestrong",
        website: "https://www.livestrong.org/ymca-search"
    ),
    SupportGroup(
        name: "Look Good Feel Better",
        description: "Sponsored by the American Cancer Society and the Cosmetic, Toiletry and Fragrance Association, Look Good Feel Better teaches beauty techniques to cancer patients during and after chemotherapy, immunotherapy and radiation.",
        image: "lookgoodfeelbetter",
        website: "https://www.lookgoodfeelbetter.org/"
    ),
    SupportGroup(
        name: "Wigs for Cancer",
        description: "Since 2008, Andrew DiSimone and staff have been volunteering cutting and styling wigs for the American Cancer Society’s Look Good Feel Better program. People experiencing medical hair loss due to cancer and cancer treatments can receive a free wig and have it cut/styled by Andrew at the Hope Lodge in New York City.",
        image: "wigsforcancer",
        website: "https://www.cancer.org/treatment/support-programs-and-services/patient-lodging/hope-lodge/new-york-city/"
    )
]
