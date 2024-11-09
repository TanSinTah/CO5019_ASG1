

class UserDetails {

  final String address;
  final String phoneNumber;
  final String icNumber;
  final String username;
  final String imageUrl;


  UserDetails({  required this.address,  required this.phoneNumber,  required this.icNumber,required this.username,required this.imageUrl });

  //function to convert snapshot to userdetails
  factory UserDetails.fromSnapshot(dynamic document){
    return UserDetails(address: document.get("address"), phoneNumber: document.get("phoneNumber"), icNumber: document.get("icNumber"), username: document.get("username"), imageUrl: document.get("imageUrl"));
  }
}