class User {
  String? idNumber;
  String? fullName;
  String? phoneNumber;
  String? gender;
  String? birthDay;
  String? schoolYear;
  String? schoolKey;
  String? dateCreated;
  String? imageURL;
  String? accountId;

  User({
    this.idNumber,
    this.fullName,
    this.phoneNumber,
    this.gender,
    this.birthDay,
    this.schoolYear,
    this.schoolKey,
    this.dateCreated,
    this.imageURL,
    this.accountId,
  });

  User.userEmpty()
      : idNumber = '',
        fullName = '',
        phoneNumber = '',
        gender = '',
        birthDay = '',
        schoolYear = '',
        schoolKey = '',
        dateCreated = '',
        imageURL = '',
        accountId = '';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idNumber: json['idNumber'] as String?,
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      gender: json['gender'] as String?,
      birthDay: json['birthDay'] as String?,
      schoolYear: json['schoolYear'] as String?,
      schoolKey: json['schoolKey'] as String?,
      dateCreated: json['dateCreated'] as String?,
      imageURL: json['imageURL'] as String?,
      accountId: json['accountId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNumber': idNumber,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'birthDay': birthDay,
      'schoolYear': schoolYear,
      'schoolKey': schoolKey,
      'dateCreated': dateCreated,
      'imageURL': imageURL,
      'accountId': accountId,
    };
  }
}
