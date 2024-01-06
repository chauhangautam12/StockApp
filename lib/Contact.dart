class Contact {
  String name;
  String contact;
  String size;
  Contact({required this.name, required this.contact, required this.size});
  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    name: json["name"],
    contact: json["contact"], size:json["size"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "contact": contact,
    "size": size,
  };
}