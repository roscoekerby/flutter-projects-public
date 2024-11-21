class BusinessCard {
  String name;
  String businessName; // Added businessName field
  String position;
  String phone;
  String email;
  String website;
  String qrCodeWebsite;
  String? logoImagePath;

  BusinessCard({
    required this.name,
    required this.businessName, // Added businessName constructor parameter
    required this.position,
    required this.phone,
    required this.email,
    required this.website,
    required this.qrCodeWebsite,
    this.logoImagePath,
  });

  // Convert a BusinessCard object into a Map to store in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'businessName': businessName, // Added businessName to map
      'position': position,
      'phone': phone,
      'email': email,
      'website': website,
      'qrCodeWebsite': qrCodeWebsite,
      'logoImagePath': logoImagePath,
    };
  }

  // Convert a Map back into a BusinessCard object
  factory BusinessCard.fromMap(Map<String, dynamic> map) {
    return BusinessCard(
      name: map['name'],
      businessName: map['businessName'] ?? '', // Load businessName from map
      position: map['position'],
      phone: map['phone'],
      email: map['email'],
      website: map['website'],
      qrCodeWebsite: map['qrCodeWebsite'],
      logoImagePath: map['logoImagePath'],
    );
  }
}
