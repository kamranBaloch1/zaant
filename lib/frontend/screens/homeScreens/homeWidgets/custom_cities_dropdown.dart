import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  _CustomCitiesDropdownState createState() => _CustomCitiesDropdownState();
}

class _CustomCitiesDropdownState extends State<CustomCitiesDropdown> {

 final List<String> _citiesList = [
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
            padding:  EdgeInsets.only(bottom: 8.h),
            child: Text(
              widget.labelText!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ),
        TypeAheadFormField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              hintText: 'Search for a city',
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            controller: TextEditingController(text: widget.selectedCity),

            style: const TextStyle(color: Colors.black)
          ),
          suggestionsCallback: (pattern) {
            return _citiesList
                .where((city) => city.toLowerCase().contains(pattern.toLowerCase()));
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(
                suggestion,
                style: TextStyle(
                  color: suggestion == widget.selectedCity ? Colors.black : Colors.black,
                ),
              ),
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (suggestion) {
            widget.onChanged(suggestion);
          },
          noItemsFoundBuilder: (context) {
            return const ListTile(
              title: Text('No cities found',style: TextStyle(color: Colors.black),),
            );
          },
        ),
      ],
    );
  }
}
