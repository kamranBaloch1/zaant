import 'package:flutter/material.dart';

class CustomCitiesDropdown extends StatefulWidget {
  final String? selectedCity;
  final String? labelText;
  final ValueChanged<String?> onChanged;

  CustomCitiesDropdown({
    Key? key,
    required this.selectedCity,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomCitiesDropdownState createState() =>
      _CustomCitiesDropdownState();
}

class _CustomCitiesDropdownState extends State<CustomCitiesDropdown> {

 List<String> _citiesList = [
    // Balochistan
    "Quetta",
    "Gwadar",
    "Turbat",
    "Khuzdar",
    "Loralai",
    "Zhob",
    "Hub",
    "Chaman",
    "Killa Abdullah",
    "Lasbela",
    "Sibi",
    "Nushki",
    "Kharan",
    "Mastung",
    "Panjgur",
    // Islamabad Capital Territory
    "Islamabad",

    // Punjab
    "Lahore",
    "Faisalabad",
    "Rawalpindi",
    "Multan",
    "Gujranwala",
    "Sialkot",
    "Bahawalpur",
    "Sargodha",
    "Sheikhupura",
    "Jhang",
    "Gujrat",
    "Layyah",
    "Attock",
    "Rahim Yar Khan",
    "Okara",
    "Nankana Sahib",
    "Kasur",
    "Vehari",
    "Sahiwal",
    "Chiniot",
    "Toba Tek Singh",
    "Mianwali",
    "Bhakkar",
    "Khushab",
    "Dera Ghazi Khan",
    "Rajanpur",
    "Muzaffargarh",
    "Chakwal",
    "Hafizabad",
    "Narowal",
    "Lodhran",

    // Sindh
    "Karachi",
    "Hyderabad",
    "Sukkur",
    "Larkana",
    "Nawabshah",
    "Mirpur Khas",
    "Jacobabad",
    "Shikarpur",
    "Dadu",
    "Tando Adam",
    "Badin",
    "Khairpur",
    "Tando Muhammad Khan",
    "Sanghar",
    "Tharparkar",
    "Umerkot",
    "Ghotki",
    "Kamber Shahdadkot",

    // Khyber Pakhtunkhwa (KP)
    "Peshawar",
    "Abbottabad",
    "Mardan",
    "Swat",
    "Dera Ismail Khan",
    "Kohat",
    "Bannu",
    "Haripur",
    "Mansehra",
    "Charsadda",
    "Nowshera",
    "Chitral",
    "Swabi",
    "Malakand",
    "Hangu",
    "Batagram",

    // Rural Areas
    "Thar Desert",
    "Cholistan Desert",
    "Kala Dhaka",
    "Neelum Valley",
    "Gorakh Hill",
    "Deosai Plains",
    "Hingol National Park",
    "Skardu",
    "Fairy Meadows",
    "Shounter Lake",
    "Hanna Lake",
    "Keenjhar Lake",
    "Mubarak Village",
  ];




  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelText!,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black),
            ),
          ),
        DropdownButtonFormField<String>(
          value: widget.selectedCity,
          onChanged: (value) {
            setState(() {
              widget.onChanged(value);
            });
          },
          items: _citiesList.map((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(
                city,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
