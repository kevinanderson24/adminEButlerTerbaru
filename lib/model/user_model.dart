class UserModel {
  int? roomNumber;
  String? email;
  String? firstName;
  String? secondName;

  UserModel({this.roomNumber, this.email, this.firstName, this.secondName});

  //RECEIVE data from server
  factory UserModel.fromMap(map){
    return UserModel(
      roomNumber: map['roomNumber'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
    );
  }

  //SENDING data to our server
  Map<String, dynamic> toMap(){
    return{
      'roomNumber': roomNumber,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
    };
  }
}