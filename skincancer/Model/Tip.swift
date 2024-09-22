import Foundation
struct Tip: Identifiable {
    var id = UUID()
    let icon: String
    let text: String
    let expandedText: String
}

var tips = [
    Tip(icon: "pencil", text: "Check your skin regularly", expandedText: "Regularly examine your skin for any new moles, growths, or changes in existing moles. Use the ABCDE rule (Asymmetry, Border, Color, Diameter, Evolving) to identify potential warning signs of melanoma. Early detection is crucial for successful treatment."),
    
    Tip(icon: "doc.text", text: "Protect Your Skin from UV Exposures", expandedText: "Apply broad-spectrum sunscreen with an SPF of at least 30 every day, even on cloudy days. Wear protective clothing, such as wide-brimmed hats and long sleeves, and avoid tanning beds. Seek shade during peak sun hours (10 a.m. to 4 p.m.) to minimize UV exposure."),
    
    Tip(icon: "exclamationmark.triangle", text: "Follow Up with Your Dermatologist", expandedText: "If you’ve had skin cancer before or are at high risk, schedule regular check-ups with your dermatologist. They can monitor your skin for any new changes and ensure early intervention if necessary. Don’t skip appointments, as early detection is key to preventing recurrence or catching new cancers early."),
    
    Tip(icon: "lightbulb", text: "Know Your Risk Factors", expandedText: "Understand your risk factors for skin cancer, such as fair skin, a history of sunburns, excessive UV exposure, and a family history of skin cancer. Being aware of these can help you take proactive measures to protect your skin."),
    
    Tip(icon: "cross.case", text: "Use Sunscreen Correctly", expandedText: "Apply sunscreen 15-30 minutes before going outdoors and reapply every two hours, or more often if swimming or sweating. Make sure to cover all exposed skin, including often-missed areas like the ears, neck, and tops of the feet."),
    
    Tip(icon: "calendar", text: "Schedule Annual Skin Checks", expandedText: "Even if you don’t notice any changes, it’s a good idea to have a full-body skin exam by a dermatologist at least once a year, especially if you’re at high risk. Early detection through professional checks can catch skin cancer at a more treatable stage."),
    
    Tip(icon: "info.circle", text: "Avoid Tanning Beds", expandedText: "Tanning beds emit UV radiation that significantly increases your risk of skin cancer, including melanoma. It’s best to avoid them entirely and opt for safer alternatives like self-tanning products if you desire a tan."),
    
    Tip(icon: "figure.walk", text: "Be Mindful of Sun Exposure While Outdoors", expandedText: "Whether you’re at the beach, hiking, or just spending time outside, be conscious of your sun exposure. Wear protective clothing and take breaks in the shade to reduce your risk of sunburn and long-term skin damage."),
    
    Tip(icon: "thermometer.sun", text: "Don’t Forget to Protect Your Eyes and Lips", expandedText: "The skin on your lips and around your eyes is sensitive and prone to damage from UV radiation. Use lip balm with SPF and wear sunglasses that block UV rays to protect these areas.")
]
