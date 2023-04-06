import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileData {
  static List genders(BuildContext context) {
    return [
      {
        'label': 'Male',
        'value': 'Male',
        'icon': Container(
          key: UniqueKey(),
          height: 20,
          width: 20,
          child: SvgPicture.asset(
            'assets/genders/male.svg',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      },
      {
        'label': 'Female',
        'value': 'Female',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: SvgPicture.asset(
            'assets/genders/female.svg',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      },
      {
        'label': 'Genderqueer',
        'value': 'Genderqueer',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: SvgPicture.asset(
            'assets/genders/genderqueer.svg',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      },
      {
        'label': 'Non Binary',
        'value': 'Non Binary',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: SvgPicture.asset(
            'assets/genders/genderqueer.svg',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      },
      {
        'label': 'Gamer',
        'value': 'Gamer',
        'icon': Container(
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: Icon(
            Icons.videogame_asset,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      },
    ];
  }

  static List getUndergrads() {
    List _undergrads = [
      {
        'label': 'None',
        'value': 'None',
        'icon': Icons.close,
      },
      {
        'label': 'Accounting',
        'value': 'Accounting',
        'icon': Icons.account_balance,
      },
      {
        'label': 'Acting',
        'value': 'Acting',
        'icon': Icons.mic,
      },
      {
        'label': 'Advertising and Public Relations',
        'value': 'Advertising and Public Relations',
        'icon': Icons.public,
      },
      {
        'label': 'Aerospace Engineering',
        'value': 'Aerospace Engineering',
        'icon': FontAwesomeIcons.rocket,
      },
      {
        'label': 'Agribusiness Management',
        'value': 'Agribusiness Management',
        'icon': Icons.local_florist,
      },
      {
        'label': 'Agricultural and Extension Education',
        'value': 'Agricultural and Extension Education',
        'icon': Icons.school,
      },
      {
        'label': 'Animal and Nutritional Sciences',
        'value': 'Animal and Nutritional Sciences',
        'icon': Icons.pets,
      },
      {
        'label': 'Anthropology',
        'value': 'Anthropology',
        'icon': Icons.people,
      },
      {
        'label': 'Art Education',
        'value': 'Art Education',
        'icon': Icons.art_track,
      },
      {
        'label': 'Art History',
        'value': 'Art History',
        'icon': Icons.history,
      },
      {
        'label': 'Art Design',
        'value': 'Art Design',
        'icon': Icons.color_lens,
      },
      {
        'label': 'Art Therapy',
        'value': 'Art Therapy',
        'icon': Icons.healing,
      },
      {
        'label': 'Art and Design',
        'value': 'Art and Design',
        'icon': Icons.brush,
      },
      {
        'label': 'Biochemistry',
        'value': 'Biochemistry',
        'icon': FontAwesomeIcons.flask,
      },
      {
        'label': 'Biology',
        'value': 'Biology',
        'icon': Icons.functions,
      },
      {
        'label': 'Biomedical Engineering',
        'value': 'Biomedical Engineering',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Biomedical Laboratory Diagnostics',
        'value': 'Biomedical Laboratory Diagnostics',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Biometric Systems Engineering',
        'value': 'Biometric Systems Engineering',
        'icon': Icons.fingerprint,
      },
      {
        'label': 'Chemistry',
        'value': 'Chemistry',
        'icon': FontAwesomeIcons.flask,
      },
      {
        'label': 'Chinese Studies',
        'value': 'Chinese Studies',
        'icon': Icons.language,
      },
      {
        'label': 'Civil Engineering',
        'value': 'Civil Engineering',
        'icon': Icons.location_city,
      },
      {
        'label': 'Coaching and Performance Science',
        'value': 'Coaching and Performance Science',
        'icon': Icons.fitness_center,
      },
      {
        'label': 'Communication Sciences and Disorders',
        'value': 'Communication Sciences and Disorders',
        'icon': Icons.hearing,
      },
      {
        'label': 'Communication Studies',
        'value': 'Communication Studies',
        'icon': Icons.chat_bubble,
      },
      {
        'label': 'Computer Engineering',
        'value': 'Computer Engineering',
        'icon': Icons.computer,
      },
      {
        'label': 'Computer Science',
        'value': 'Computer Science',
        'icon': Icons.computer,
      },
      {
        'label': 'Criminology',
        'value': 'Criminology',
        'icon': Icons.security,
      },
      {
        'label': 'Cybersecurity',
        'value': 'Cybersecurity',
        'icon': Icons.security,
      },
      {
        'label': 'Dance',
        'value': 'Dance',
        'icon': Icons.directions_run,
      },
      {
        'label': 'Data Science',
        'value': 'Data Science',
        'icon': Icons.storage,
      },
      {
        'label': 'Dental Hygiene',
        'value': 'Dental Hygiene',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Design Studies',
        'value': 'Design Studies',
        'icon': Icons.create,
      },
      {
        'label': 'Economics',
        'value': 'Economics',
        'icon': Icons.attach_money,
      },
      {
        'label': 'Electrical Engineering',
        'value': 'Electrical Engineering',
        'icon': Icons.power,
      },
      {
        'label': 'Elementary Education',
        'value': 'Elementary Education',
        'icon': Icons.school,
      },
      {
        'label': 'Energy Land Management',
        'value': 'Energy Land Management',
        'icon': FontAwesomeIcons.lightbulb,
      },
      {
        'label': 'English',
        'value': 'English',
        'icon': Icons.book,
      },
      {
        'label': 'Entrepreneurship and Innovation',
        'value': 'Entrepreneurship and Innovation',
        'icon': Icons.business,
      },
      {
        'label': 'Geosciences',
        'value': 'Geosciences',
        'icon': Icons.nature,
      },
      {
        'label': 'Gerontology',
        'value': 'Gerontology',
        'icon': FontAwesomeIcons.grin,
      },
      {
        'label': 'Graphic Design',
        'value': 'Graphic Design',
        'icon': Icons.color_lens,
      },
      {
        'label': 'Health and Physical Education',
        'value': 'Health and Physical Education',
        'icon': Icons.fitness_center,
      },
      {
        'label': 'Health Informatics',
        'value': 'Health Informatics',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Health Sciences',
        'value': 'Health Sciences',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'History',
        'value': 'History',
        'icon': Icons.history,
      },
      {
        'label': 'Hospitality Management',
        'value': 'Hospitality Management',
        'icon': Icons.hotel,
      },
      {
        'label': 'Human Development and Family Studies',
        'value': 'Human Development and Family Studies',
        'icon': Icons.people,
      },
      {
        'label': 'Human Resource Management',
        'value': 'Human Resource Management',
        'icon': Icons.people,
      },
      {
        'label': 'Individual and Family Studies',
        'value': 'Individual and Family Studies',
        'icon': Icons.people,
      },
      {
        'label': 'Industrial Engineering',
        'value': 'Industrial Engineering',
        'icon': Icons.settings,
      },
      {
        'label': 'Information Sciences and Technology',
        'value': 'Information Sciences and Technology',
        'icon': Icons.computer,
      },
      {
        'label': 'Integrative Biosciences',
        'value': 'Integrative Biosciences',
        'icon': Icons.functions,
      },
      {
        'label': 'Interior Design',
        'value': 'Interior Design',
        'icon': Icons.home,
      },
      {
        'label': 'International Business',
        'value': 'International Business',
        'icon': Icons.business,
      },
      {
        'label': 'Journalism',
        'value': 'Journalism',
        'icon': Icons.library_books,
      },
      {
        'label': 'Kinesiology',
        'value': 'Kinesiology',
        'icon': Icons.fitness_center,
      },
      {
        'label': 'Latin American Studies',
        'value': 'Latin American Studies',
        'icon': Icons.language,
      },
      {
        'label': 'Legal Studies',
        'value': 'Legal Studies',
        'icon': Icons.gavel,
      },
      {
        'label': 'Linguistics',
        'value': 'Linguistics',
        'icon': Icons.language,
      },
      {
        'label': 'Management',
        'value': 'Management',
        'icon': Icons.business,
      },
      {
        'label': 'Marketing',
        'value': 'Marketing',
        'icon': Icons.shopping_cart,
      },
      {
        'label': 'Mathematical Sciences',
        'value': 'Mathematical Sciences',
        'icon': Icons.functions,
      },
      {
        'label': 'Mechanical Engineering',
        'value': 'Mechanical Engineering',
        'icon': Icons.settings,
      },
      {
        'label': 'Medical Laboratory Sciences',
        'value': 'Medical Laboratory Sciences',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Microbiology',
        'value': 'Microbiology',
        'icon': Icons.functions,
      },
      {
        'label': 'Military Science',
        'value': 'Military Science',
        'icon': Icons.security,
      },
      {
        'label': 'Music Education',
        'value': 'Music Education',
        'icon': Icons.music_note,
      },
      {
        'label': 'Music Therapy',
        'value': 'Music Therapy',
        'icon': Icons.music_note,
      },
      {
        'label': 'Music',
        'value': 'Music',
        'icon': Icons.music_note,
      },
      {
        'label': 'Nursing',
        'value': 'Nursing',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Nutrition',
        'value': 'Nutrition',
        'icon': Icons.fastfood,
      },
      {
        'label': 'Philosophy',
        'value': 'Philosophy',
        'icon': Icons.lightbulb_outline,
      },
      {
        'label': 'Physical Therapy',
        'value': 'Physical Therapy',
        'icon': Icons.fitness_center,
      },
      {
        'label': 'Political Science',
        'value': 'Political Science',
        'icon': Icons.gavel,
      },
      {
        'label': 'Psychology',
        'value': 'Psychology',
        'icon': Icons.lightbulb_outline,
      },
      {
        'label': 'Public Health',
        'value': 'Public Health',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Public Relations',
        'value': 'Public Relations',
        'icon': Icons.people,
      },
      {
        'label': 'Real Estate',
        'value': 'Real Estate',
        'icon': Icons.home,
      },
      {
        'label': 'Recreation, Park, and Tourism Management',
        'value': 'Recreation, Park, and Tourism Management',
        'icon': Icons.beach_access,
      },
      {
        'label': 'Rehabilitation Services',
        'value': 'Rehabilitation Services',
        'icon': Icons.fitness_center,
      },
      {
        'label': 'Religious Studies',
        'value': 'Religious Studies',
        'icon': FontAwesomeIcons.pray,
      },
      {
        'label': 'Secondary Education',
        'value': 'Secondary Education',
        'icon': Icons.school,
      },
      {
        'label': 'Social Work',
        'value': 'Social Work',
        'icon': Icons.people,
      },
      {
        'label': 'Sociology',
        'value': 'Sociology',
        'icon': Icons.people,
      },
      {
        'label': 'Spanish',
        'value': 'Spanish',
        'icon': Icons.language,
      },
      {
        'label': 'Special Education',
        'value': 'Special Education',
        'icon': Icons.school,
      },
      {
        'label': 'Speech Pathology',
        'value': 'Speech Pathology',
        'icon': Icons.hearing,
      },
      {
        'label': 'Sport Management',
        'value': 'Sport Management',
        'icon': Icons.fitness_center,
      },
      {
        'label': 'Statistics',
        'value': 'Statistics',
        'icon': Icons.functions,
      },
      {
        'label': 'Theatre',
        'value': 'Theatre',
        'icon': Icons.theaters,
      },
      {
        'label': 'Undeclared',
        'value': 'Undeclared',
        'icon': Icons.help,
      },
      {
        'label': 'Women\'s Studies',
        'value': 'Women\'s Studies',
        'icon': Icons.people,
      },
      {
        'label': 'World Language Education',
        'value': 'World Language Education',
        'icon': Icons.language,
      },
      {
        'label': 'Writing, Rhetoric, and Technical Communication',
        'value': 'Writing, Rhetoric, and Technical Communication',
        'icon': Icons.library_books,
      },
      {
        'label': 'Zoology',
        'value': 'Zoology',
        'icon': Icons.pets,
      },
      {
        'label': 'Forensic Chemistry',
        'value': 'Forensic Chemistry',
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Wildlife and Forestry',
        'value': 'Wildlife and Forestry',
        'icon': Icons.pets,
      },
    ];

    _undergrads.sort((a, b) => a['label'].compareTo(b['label']));
    return _undergrads;
  }

  static List<DropDownValueModel> getUndergraddropDownValueModels(
      List undergrads) {
    List<DropDownValueModel> _undergradDropDownValueModels = [];
    for (var undergrad in undergrads) {
      _undergradDropDownValueModels.add(DropDownValueModel(
          name: undergrad['label'], value: undergrad['value']));
    }
    return _undergradDropDownValueModels;
  }

  static List getPostGrads() {
    List _postgrads = [
      {
        'label': 'Agriculture',
        'value': 'Agriculture',
      },
      {
        'label': 'PA School',
        'value': 'PA School',
      },
      {
        'label': 'None',
        'value': 'None',
      },
      {
        'label': 'Landscape Architecture',
        'value': 'Landscape Architecture',
      },
      {
        'label': 'Science in Forestry',
        'value': 'Science in Forestry',
      },
      {
        'label': 'Counseling',
        'value': 'Counseling',
      },
      {
        'label': 'Digital Technologies and Connected Learning',
        'value': 'Digital Technologies and Connected Learning',
      },
      {
        'label': 'Education and Teaching Certification (MAC)',
        'value': 'Education and Teaching Certification (MAC)',
      },
      {
        'label': 'Elementary Mathematics Specialist',
        'value': 'Elementary Mathematics Specialist',
      },
      {
        'label': 'Higher Education Administration',
        'value': 'Higher Education Administration',
      },
      {
        'label': 'Instructional Design and Technology',
        'value': 'Instructional Design and Technology',
      },
      {
        'label': 'Literacy Education',
        'value': 'Literacy Education',
      },
      {
        'label': 'Clinical Rehabilitation and Mental Health Counseling',
        'value': 'Clinical Rehabilitation and Mental Health Counseling',
      },
      {
        'label': 'Coaching and Sport Education',
        'value': 'Coaching and Sport Education',
      },
      {
        'label': 'Sport Education',
        'value': 'Sport Education',
      },
      {
        'label': 'Physical Education Teacher Education',
        'value': 'Physical Education Teacher Education',
      },
      {
        'label': 'Sport Management',
        'value': 'Sport Management',
      },
      {
        'label': 'Higher Education Administration',
        'value': 'Higher Education Administration',
      },
      {
        'label': 'Educational Theory and Practice',
        'value': 'Educational Theory and Practice',
      },
      {
        'label': 'Higher Education',
        'value': 'Higher Education',
      },
      {
        'label': 'Kinesiology',
        'value': 'Kinesiology',
      },
      {
        'label': 'Med school - 1st year',
        'value': 'Med school - 1st year',
      },
      {
        'label': 'Med school - 2nd year',
        'value': 'Med school - 2nd year',
      },
      {
        'label': 'Med school - 3rd year',
        'value': 'Med school - 3rd year',
      },
      {
        'label': 'Med school - 4th year',
        'value': 'Med school - 4th year',
      },
      {
        'label': 'Dental School',
        'value': 'Dental School',
      },
      {
        'label': 'MPA program',
        'value': 'MPA program',
      },
      {
        'label': 'MBA program',
        'value': 'MBA program',
      },
      {
        'label': 'CS Grad school stuff',
        'value': 'CS Grad school stuff',
      },
      {
        'label': 'Social Media Marketing',
        'value': 'Social Media Marketing',
      },
      {
        'label': 'Law School',
        'value': 'Law School',
      },
      {
        'label': 'Pharmacy School',
        'value': 'Pharmacy School',
      },
      {
        'label': 'Nursing School',
        'value': 'Nursing School',
      },
    ];

    //sort the list
    _postgrads.shuffle();

    return _postgrads;
  }

  static List<DropDownValueModel> getPostGraddropDownValueModels(
      List postgrads) {
    List<DropDownValueModel> _postgradDropDownValueModels = [];
    for (var postgrad in postgrads) {
      _postgradDropDownValueModels.add(DropDownValueModel(
          name: postgrad['label'], value: postgrad['value']));
    }
    return _postgradDropDownValueModels;
  }
}
