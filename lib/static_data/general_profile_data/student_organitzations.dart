import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class StudentOrganizations {
  static List getOrganizations() {
    List _organizations = [
      {
        'label': '100 Black Women at WVU',
        'value': '100 Black Women at WVU',
      },
      {
        'label': '168 Society',
        'value': '168 Society',
      },
      {
        'label': 'Launch Lab',
        'value': 'Launch Lab',
      },
      {
        'label': 'Student Government',
        'value': 'Student Government',
      },
      {
        'label': 'A Moment of Magic',
        'value': 'A Moment of Magic',
      },
      {
        'label': 'Actuarial Club',
        'value': 'Actuarial Club',
      },
      {
        'label': 'Adventure WV',
        'value': 'Adventure WV',
      },
      {
        'label': 'African Students Association',
        'value': 'African Students Association',
      },
      {
        'label': 'Agricultural Professional Society',
        'value': 'Agricultural Professional Society',
      },
      {
        'label': 'Air Force ROTC',
        'value': 'Air Force ROTC',
      },
      {
        'label': 'Alternative Resolution Society',
        'value': 'Alternative Resolution Society',
      },
      {
        'label': 'Ameatuer Radio Club',
        'value': 'Ameatuer Radio Club',
      },
      {
        'label': 'ACLU of WVU',
        'value': 'ACLU of WVU',
      },
      {
        'label': 'American Constitution Society',
        'value': 'American Constitution Society',
      },
      {
        'label': 'American Marketing Association',
        'value': 'American Marketing Association',
      },
      {
        'label': 'Appalachian Advocacy WVU',
        'value': 'Appalachian Advocacy WVU',
      },
      {
        'label': 'Arabic Studies Club',
        'value': 'Arabic Studies Club',
      },
      {
        'label': 'Arnold Air Safety',
        'value': 'Arnold Air Safety',
      },
      {
        'label': 'Art History Club',
        'value': 'Art History Club',
      },
      {
        'label': 'Artificial Intelligence WVU',
        'value': 'Artificial Intelligence WVU',
      },
      {
        'label': 'Asian Association',
        'value': 'Asian Association',
      },
      {
        'label': 'Astronomy Association',
        'value': 'Astronomy Association',
      },
      {
        'label': 'Autism Speaks U',
        'value': 'Autism Speaks U',
      },
      {
        'label': 'Backcountry Hunters and Anglers',
        'value': 'Backcountry Hunters and Anglers',
      },
      {
        'label': 'Bangledeshi Student Association',
        'value': 'Bangledeshi Student Association',
      },
      {
        'label': 'Baptist Campus Minitstry',
        'value': 'Baptist Campus Minitstry',
      },
      {
        'label': 'Baskets of Love',
        'value': 'Baskets of Love',
      },
      {
        'label': 'Best Buddies International',
        'value': 'Best Buddies International',
      },
      {
        'label': 'BJJ and MMA Club',
        'value': 'BJJ and MMA Club',
      },
      {
        'label': 'Blackbirds Club',
        'value': 'Blackbirds Club',
      },
      {
        'label': 'Block and Bridle Club',
        'value': 'Block and Bridle Club',
      },
      {
        'label': 'C2 College and Career',
        'value': 'C2 College and Career',
      },
      {
        'label': 'Campus Recreation',
        'value': 'Campus Recreation',
      },
      {
        'label': 'Career Services Center',
        'value': 'Career Services Center',
      },
      {
        'label': 'Cheat River Review',
        'value': 'Cheat River Review',
      },
      {
        'label': 'Chess Club',
        'value': 'Chess Club',
      },
      {
        'label': 'Clear the Stress',
        'value': 'Clear the Stress',
      },
      {
        'label': 'Club Rifle Team',
        'value': 'Club Rifle Team',
      },
      {
        'label': 'College Democrats of WVU',
        'value': 'College Democrats of WVU',
      },
      {
        'label': 'Collegite Gaming Club',
        'value': 'Collegite Gaming Club',
      },
      {
        'label': 'Collegiate Gaming Federation',
        'value': 'Collegiate Gaming Federation',
      },
      {
        'label': 'Commuters of Morgantown',
        'value': 'Commuters of Morgantown',
      },
      {
        'label': 'Competitive Sports',
        'value': 'Competitive Sports',
      },
      {
        'label': 'Council of Writers',
        'value': 'Council of Writers',
      },
      {
        'label': 'Criminal Law Society',
        'value': 'Criminal Law Society',
      },
      {
        'label': 'Criminology Club',
        'value': 'Criminology Club',
      },
      {
        'label': 'Cyber WVU',
        'value': 'Cyber WVU',
      },
      {
        'label': 'Davis College Graduate Student Association',
        'value': 'Davis College Graduate Student Association',
      },
      {
        'label': 'Defense Trial Council',
        'value': 'Defense Trial Council',
      },
      {
        'label': 'Delight Ministries',
        'value': 'Delight Ministries',
      },
      {
        'label': 'Design, Build, Fly Club',
        'value': 'Design, Build, Fly Club',
      },
      {
        'label': 'Diabuddies',
        'value': 'Diabuddies',
      },
      {
        'label': 'Engineers without Borders',
        'value': 'Engineers without Borders',
      },
      {
        'label': 'English Graduate Student Union',
        'value': 'English Graduate Student Union',
      },
      {
        'label': 'Enviromental Law Society',
        'value': 'Enviromental Law Society',
      },
      {
        'label': 'Exercise Phys Club',
        'value': 'Exercise Phys Club',
      },
      {
        'label': 'Fasion Business Assosiation',
        'value': 'Fasion Business Assosiation',
      },
      {
        'label': 'Fellowship of Christian Athletes',
        'value': 'Fellowship of Christian Athletes',
      },
      {
        'label': 'Fencing Club WVU',
        'value': 'Fencing Club WVU',
      },
      {
        'label': 'Filipino Student Association',
        'value': 'Filipino Student Association',
      },
      {
        'label': 'Finance Club',
        'value': 'Finance Club',
      },
      {
        'label': 'Flow Arts Club',
        'value': 'Flow Arts Club',
      },
      {
        'label': 'Food Recovery Network',
        'value': 'Food Recovery Network',
      },
      {
        'label': 'Forensic and Investigative Club',
        'value': 'Forensic and Investigative Club',
      },
      {
        'label': 'Game Developers Club',
        'value': 'Game Developers Club',
      },
      {
        'label': 'Genesis KDC at WVU',
        'value': 'Genesis KDC at WVU',
      },
      {
        'label': 'Geo Graduate Group',
        'value': 'Geo Graduate Group',
      },
      {
        'label': 'Get Down',
        'value': 'Get Down',
      },
      {
        'label': 'Global Dentist Brigades',
        'value': 'Global Dentist Brigades',
      },
      {
        'label': 'Global Medical Brigade',
        'value': 'Global Medical Brigade',
      },
      {
        'label': 'Her Campus at WVU',
        'value': 'Her Campus at WVU',
      },
      {
        'label': 'Honors College',
        'value': 'Honors College',
      },
      {
        'label': 'Honors Student Association',
        'value': 'Honors Student Association',
      },
      {
        'label': 'Hospitality Club',
        'value': 'Hospitality Club',
      },
      {
        'label': 'Human Anatomy Club',
        'value': 'Human Anatomy Club',
      },
      {
        'label': 'Italian Studies Club',
        'value': 'Italian Studies Club',
      },
      {
        'label': 'Jane Austen Book Club',
        'value': 'Jane Austen Book Club',
      },
      {
        'label': 'Labor Law Society',
        'value': 'Labor Law Society',
      },
      {
        'label': 'Law and Economics Club',
        'value': 'Law and Economics Club',
      },
      {
        'label': 'Machine Learning Club',
        'value': 'Machine Learning Club',
      },
      {
        'label': 'Men\'s Basketball Club',
        'value': 'Men\'s Basketball Club',
      },
      {
        'label': 'Men\s Club Soccer',
        'value': 'Men\s Club Soccer',
      },
      {
        'label': 'Men\s Volleyball Club',
        'value': 'Men\s Volleyball Club',
      },
      {
        'label': 'Mi Gente',
        'value': 'Mi Gente',
      },
      {
        'label': 'Middle Eastern Student Association',
        'value': 'Middle Eastern Student Association',
      },
      {
        'label': 'Mirage Magazine',
        'value': 'Mirage Magazine',
      },
      {
        'label': 'Model UN',
        'value': 'Model UN',
      },
      {
        'label': 'Mon Hills Music Group',
        'value': 'Mon Hills Music Group',
      },
      {
        'label': 'Morgan\s Message',
        'value': 'Morgan\s Message',
      },
      {
        'label': 'Morgantown Roller Vixens',
        'value': 'Morgantown Roller Vixens',
      },
      {
        'label': 'Mountaineer Animal Rights Center',
        'value': 'Mountaineer Animal Rights Center',
      },
      {
        'label': 'Mountaineer Cubing Club',
        'value': 'Mountaineer Cubing Club',
      },
      {
        'label': 'Mountaineer Mentors',
        'value': 'Mountaineer Mentors',
      },
      {
        'label': 'Mountaineers For Life',
        'value': 'Mountaineers For Life',
      },
      {
        'label': 'Mountaineers for Recovery',
        'value': 'Mountaineers for Recovery',
      },
      {
        'label': 'Music and Health Club',
        'value': 'Music and Health Club',
      },
      {
        'label': 'Omani Student Association',
        'value': 'Omani Student Association',
      },
      {
        'label': 'Outdoor Adventure Club',
        'value': 'Outdoor Adventure Club',
      },
      {
        'label': 'OUTLaw',
        'value': 'OUTLaw',
      },
      {
        'label': 'Photography Club',
        'value': 'Photography Club',
      },
      {
        'label': 'Pre-Dental Club',
        'value': 'Pre-Dental Club',
      },
      {
        'label': 'Project 168',
        'value': 'Project 168',
      },
      {
        'label': 'Psychology Club',
        'value': 'Psychology Club',
      },
      {
        'label': 'Quadball',
        'value': 'Quadball',
      },
      {
        'label': 'Quiz Bowl Club',
        'value': 'Quiz Bowl Club',
      },
      {
        'label': 'Residence Hall Association',
        'value': 'Residence Hall Association',
      },
      {
        'label': 'Sociaology Club',
        'value': 'Sociaology Club',
      },
      {
        'label': 'Spectrum',
        'value': 'Spectrum',
      },
      {
        'label': 'Student Dance Assosiation',
        'value': 'Student Dance Assosiation',
      },
      {
        'label': 'Student Government Association',
        'value': 'Student Government Association',
      },
      {
        'label': 'Student Investment Club',
        'value': 'Student Investment Club',
      },
      {
        'label': 'Take Me Home Accapella',
        'value': 'Take Me Home Accapella',
      },
      {
        'label': 'TEDxWVU',
        'value': 'TEDxWVU',
      },
      {
        'label': 'The Federalist Society',
        'value': 'The Federalist Society',
      },
      {
        'label': 'The Mountaineer Maniacs',
        'value': 'The Mountaineer Maniacs',
      },
      {
        'label': 'The Rack',
        'value': 'The Rack',
      },
      {
        'label': 'The Self Love Club',
        'value': 'The Self Love Club',
      },
      {
        'label': 'UX/UI Club',
        'value': 'UX/UI Club',
      },
      {
        'label': 'The WVU Math Club',
        'value': 'The WVU Math Club',
      },
      {
        'label': 'Turning Point USA',
        'value': 'Turning Point USA',
      },
      {
        'label': 'Ukraine Mountaineers Association',
        'value': 'Ukraine Mountaineers Association',
      },
      {
        'label': 'Veterans of WVU',
        'value': 'Veterans of WVU',
      },
      {
        'label': 'Well WVU',
        'value': 'Well WVU',
      },
      {
        'label': 'WVU Cheddar Bay Biscuits Club',
        'value': 'WVU Cheddar Bay Biscuits Club',
      },
      {
        'label': 'WVU Club Dodgeball',
        'value': 'WVU Club Dodgeball',
      },
      {
        'label': 'WVU Cricket Club',
        'value': 'WVU Cricket Club',
      },
      {
        'label': 'Film Club',
        'value': 'Film Club',
      },
      {
        'label': 'Disc Golf Club',
        'value': 'Disc Golf Club',
      },
      {
        'label': 'Fishing Club',
        'value': 'Fishing Club',
      },
      {
        'label': 'Japanese Club',
        'value': 'Japanese Club',
      },
      {
        'label': 'Korean Club',
        'value': 'Korean Club',
      },
      {
        'label': 'Men\s Rowing',
        'value': 'Men\s Rowing',
      },
      {
        'label': 'Paintball Club',
        'value': 'Paintball Club',
      },
      {
        'label': 'Squash Club',
        'value': 'Squash Club',
      },
      {
        'label': 'Track Club',
        'value': 'Track Club',
      },
      {
        'label': 'WeightLifting Club',
        'value': 'WeightLifting Club',
      },
      {
        'label': 'Western Equestrian Team',
        'value': 'Western Equestrian Team',
      },
      {
        'label': 'Wome\'s Basketball',
        'value': 'Wome\'s Basketball',
      },
      {
        'label': 'Women\'s Club Soccer',
        'value': 'Women\'s Club Soccer',
      },
      {
        'label': 'Airsoft Club',
        'value': 'Airsoft Club',
      },
      {
        'label': 'Red Cross',
        'value': 'Red Cross',
      },
      {
        'label': 'Anthropology Club',
        'value': 'Anthropology Club',
      },
      {
        'label': 'Archery Club',
        'value': 'Archery Club',
      },
      {
        'label': 'Badmiton Club',
        'value': 'Badmiton Club',
      },
      {
        'label': 'Beekeeping Club',
        'value': 'Beekeeping Club',
      },
      {
        'label': 'Boxing Club',
        'value': 'Boxing Club',
      },
      {
        'label': 'Biochem Club',
        'value': 'Biochem Club',
      },
      {
        'label': 'Chinese Club',
        'value': 'Chinese Club',
      },
      {
        'label': 'Clay Club',
        'value': 'Clay Club',
      },
      {
        'label': 'Climbing Club',
        'value': 'Climbing Club',
      },
      {
        'label': 'Field Hockey',
        'value': 'Field Hockey',
      },
      {
        'label': 'Club Gymnastics',
        'value': 'Club Gymnastics',
      },
      {
        'label': 'Club Softball',
        'value': 'Club Softball',
      },
      {
        'label': 'Club Tennis',
        'value': 'Club Tennis',
      },
      {
        'label': 'Coding Club',
        'value': 'Coding Club',
      },
      {
        'label': 'Competitive Cheer',
        'value': 'Competitive Cheer',
      },
      {
        'label': 'Creative Writing',
        'value': 'Creative Writing',
      },
      {
        'label': 'Cycling Club',
        'value': 'Cycling Club',
      },
      {
        'label': 'Dairy Science Club',
        'value': 'Dairy Science Club',
      },
      {
        'label': 'Dance Team',
        'value': 'Dance Team',
      },
      {
        'label': 'Data Science Club',
        'value': 'Data Science Club',
      },
      {
        'label': 'Figure Skating Club',
        'value': 'Figure Skating Club',
      },
      {
        'label': 'Fly Fishing Club',
        'value': 'Fly Fishing Club',
      },
      {
        'label': 'Forestry Club',
        'value': 'Forestry Club',
      },
      {
        'label': 'French Club',
        'value': 'French Club',
      },
      {
        'label': 'German Club',
        'value': 'German Club',
      },
      {
        'label': 'History Club',
        'value': 'History Club',
      },
      {
        'label': 'Horticulture Club',
        'value': 'Horticulture Club',
      },
      {
        'label': 'Men\'s Lacrosse',
        'value': 'Men\'s Lacrosse',
      },
      {
        'label': 'WV Libraries',
        'value': 'WV Libraries',
      },
    ];

    _organizations.shuffle();

    List _myFaves = [
      {
        'label': 'Horticulture Club',
        'value': 'Horticulture Club',
      },
      {
        'label': 'Swim Club',
        'value': 'Swim Club',
      },
      {
        'label': 'WVU PAWS',
        'value': 'WVU PAWS',
      },
      {
        'label': 'Student Grotto',
        'value': 'Student Grotto',
      },
      {
        'label': 'Entrepreneur Club',
        'value': 'Entrepreneur Club',
      },
    ];

    //add my faves to the top of the list
    _organizations.insertAll(0, _myFaves);

    return _organizations;
  }

  static List<DropDownValueModel> getOrganizationdropDownValueModels(
      List organizations) {
    List<DropDownValueModel> _undergradDropDownValueModels = [];
    for (var organization in organizations) {
      _undergradDropDownValueModels.add(DropDownValueModel(
          name: organization['label'], value: organization['value']));
    }
    return _undergradDropDownValueModels;
  }
}
