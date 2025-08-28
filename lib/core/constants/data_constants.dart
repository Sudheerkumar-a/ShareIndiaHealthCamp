import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';

const String contactNumber = "067641000";
const String contactEmail = "info@uaqgov.ae";
const String contactWhatsAppLink = "https://wa.me/971569901116";
const String ambulanceNumber = "998";
const String policeNumber = "999";
const String civilDefenseNumber = "997";
const String electricityNumber = "991";
const String waterNumber = "992";
const String servicesInListView = "LIST";
const String servicesInGridView = "GRID";
const int maxUploadFilesize = 1024 * 1024 * 5;

const mobileRegx = r'^05[0-9]{8}$';
const emailTemplatePath = 'assets/json/email_template.txt';
const requestService = 'assets/json/request_service.json';

final mandals = List<NameIDEntity>.empty(growable: true);
final months = [
  NameIDEntity()
    ..id = 1
    ..name = "January",
  NameIDEntity()
    ..id = 2
    ..name = "February",
  NameIDEntity()
    ..id = 3
    ..name = "March",
  NameIDEntity()
    ..id = 4
    ..name = "April",
  NameIDEntity()
    ..id = 5
    ..name = "May",
  NameIDEntity()
    ..id = 6
    ..name = "June",
  NameIDEntity()
    ..id = 7
    ..name = "July",
  NameIDEntity()
    ..id = 8
    ..name = "August",
  NameIDEntity()
    ..id = 9
    ..name = "September",
  NameIDEntity()
    ..id = 10
    ..name = "October",
  NameIDEntity()
    ..id = 11
    ..name = "November",
  NameIDEntity()
    ..id = 12
    ..name = "December",
];

const districts = [
  {"id": "4", "name": "ALLURI SITARAMARAJU"},
  {"id": "6", "name": "ANAKAPALLI"},
  {"id": "21", "name": "ANANTAPURAMU"},
  {"id": "24", "name": "ANNAMAYYA"},
  {"id": "14", "name": "BAPATLA"},
  {"id": "25", "name": "CHITTOOR"},
  {"id": "9", "name": "EAST GODAVARI"},
  {"id": "11", "name": "ELURU"},
  {"id": "16", "name": "GUNTUR"},
  {"id": "7", "name": "KAKINADA"},
  {"id": "8", "name": "KONASEEMA"},
  {"id": "12", "name": "KRISHNA"},
  {"id": "19", "name": "KURNOOL"},
  {"id": "20", "name": "NANDHYAL"},
  {"id": "17", "name": "NTR"},
  {"id": "15", "name": "PALNADU"},
  {"id": "3", "name": "PARVATHIPURAM MANYAM"},
  {"id": "13", "name": "PRAKASAM"},
  {"id": "18", "name": "SRI POTTI SRIRAMULU NELLORE"},
  {"id": "22", "name": "SRI SATYA SAI"},
  {"id": "1", "name": "SRIKAKULAM"},
  {"id": "26", "name": "TIRUPATHI"},
  {"id": "5", "name": "VISAKHAPATNAM"},
  {"id": "2", "name": "VIZIANAGARAM"},
  {"id": "10", "name": "WEST GODAVARI"},
  {"id": "23", "name": "YSR"},
];

final occupation = [
  NameIDEntity()
    ..id = 1
    ..name = 'Agriculture Labourer',
  NameIDEntity()
    ..id = 2
    ..name = 'Agricultural Cultivator / Landholder',
  NameIDEntity()
    ..id = 3
    ..name = 'Housewife',
  NameIDEntity()
    ..id = 4
    ..name = 'Student',
  NameIDEntity()
    ..id = 5
    ..name = 'Business',
  NameIDEntity()
    ..id = 6
    ..name = 'Govt / Pvt Employee',
  NameIDEntity()
    ..id = 7
    ..name = 'Truck Driver / Helper',
  NameIDEntity()
    ..id = 8
    ..name = 'Hotel Staff',
  NameIDEntity()
    ..id = 9
    ..name = 'Unemployed / Retired',
  NameIDEntity()
    ..id = 10
    ..name = 'Others (Specify…)',
];
final gender = [
  NameIDEntity()
    ..id = 1
    ..name = 'M',
  NameIDEntity()
    ..id = 2
    ..name = 'F',
  NameIDEntity()
    ..id = 3
    ..name = 'TG',
];

final maritalStatus = [
  NameIDEntity()
    ..id = 1
    ..name = 'Single',
  NameIDEntity()
    ..id = 2
    ..name = 'Married',
  NameIDEntity()
    ..id = 3
    ..name = 'Living together / Cohabiting',
  NameIDEntity()
    ..id = 4
    ..name = 'Separated',
  NameIDEntity()
    ..id = 5
    ..name = 'Divorced',
  NameIDEntity()
    ..id = 6
    ..name = 'Widowed',
  NameIDEntity()
    ..id = 7
    ..name = 'Prefer not to say',
  NameIDEntity()
    ..id = 8
    ..name = 'Not applicable',
];
const syndromicCases = [
  {"id": '1', "name": "Urethral Discharge"},
  {"id": '2', "name": "Vaginal Discharge"},
  {"id": '3', "name": "Painful Scrotal Swelling"},
  {"id": '4', "name": "Vaginal Discharge Syndrome (for vaginitis)"},
  {
    "id": '5',
    "name": "Genital Ulcer Disease Syndrome (for Syphilis and Chancroid)",
  },
  {
    "id": '6',
    "name":
        "Genital Ulcer Disease Syndrome (for Syphilis and Chancroid when unavailability or history of allergy to BPG)",
  },
  {"id": '7', "name": "Genital Ulcer Disease Syndrome (for Herpetic Ulcers)"},
  {"id": '8', "name": "Lower Abdomen Pain"},
  {"id": '9', "name": "Pelvic Inflammatory Disease"},
  {"id": '10', "name": "Inguinal Bubo under Genital Ulcer Disease Syndrome"},
  {"id": '11', "name": "LGV Proctitis under Anorectal Discharge Syndrome"},
  {"id": '12', "name": "Anorectal Discharge Syndrome"},
  {"id": '13', "name": "No symptoms"},
];
