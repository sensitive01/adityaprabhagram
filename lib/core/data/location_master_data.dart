class VillageRecord {
  final String villageName;
  final String lgdCode;
  final String gramPanchayat;
  final String policeStationPostOffice;

  const VillageRecord({
    required this.villageName,
    required this.lgdCode,
    required this.gramPanchayat,
    required this.policeStationPostOffice,
  });
}

class LocationMasterData {
  // Master hierarchy: State -> District -> City / Block -> List<VillageRecord>
  static final Map<String, Map<String, Map<String, List<VillageRecord>>>> hierarchy = {
    'Andhra Pradesh': {
      'Anantapur': {
        'Anantapur Urban': [
          const VillageRecord(
            villageName: 'Anantapur Rural',
            lgdCode: '591001',
            gramPanchayat: 'Anantapur GP',
            policeStationPostOffice: 'Anantapur PS / PO 515001',
          ),
          const VillageRecord(
            villageName: 'Kakkalapalle',
            lgdCode: '591002',
            gramPanchayat: 'Kakkalapalle GP',
            policeStationPostOffice: 'Anantapur PS / PO 515002',
          ),
          const VillageRecord(
            villageName: 'Papampeta',
            lgdCode: '591003',
            gramPanchayat: 'Papampeta GP',
            policeStationPostOffice: 'Anantapur PS / PO 515004',
          ),
        ],
        'Dharmavaram': [
          const VillageRecord(
            villageName: 'Dharmavaram Rural',
            lgdCode: '591010',
            gramPanchayat: 'Dharmavaram GP',
            policeStationPostOffice: 'Dharmavaram PS / PO 515671',
          ),
          const VillageRecord(
            villageName: 'Gotluru',
            lgdCode: '591011',
            gramPanchayat: 'Gotluru GP',
            policeStationPostOffice: 'Dharmavaram PS / PO 515671',
          ),
        ],
        'Guntakal': [
          const VillageRecord(
            villageName: 'Guntakal Rural',
            lgdCode: '591020',
            gramPanchayat: 'Guntakal GP',
            policeStationPostOffice: 'Guntakal PS / PO 515801',
          ),
          const VillageRecord(
            villageName: 'Kasapuram',
            lgdCode: '591021',
            gramPanchayat: 'Kasapuram GP',
            policeStationPostOffice: 'Guntakal PS / PO 515803',
          ),
        ],
      },
      'Chittoor': {
        'Chittoor Urban': [
          const VillageRecord(
            villageName: 'Murakambattu',
            lgdCode: '592001',
            gramPanchayat: 'Murakambattu GP',
            policeStationPostOffice: 'Chittoor PS / PO 517001',
          ),
          const VillageRecord(
            villageName: 'Mangasamudram',
            lgdCode: '592002',
            gramPanchayat: 'Mangasamudram GP',
            policeStationPostOffice: 'Chittoor PS / PO 517002',
          ),
        ],
        'Tirupati': [
          const VillageRecord(
            villageName: 'Avilala',
            lgdCode: '592010',
            gramPanchayat: 'Avilala GP',
            policeStationPostOffice: 'Tirupati PS / PO 517501',
          ),
          const VillageRecord(
            villageName: 'Perur',
            lgdCode: '592011',
            gramPanchayat: 'Perur GP',
            policeStationPostOffice: 'Tirupati PS / PO 517505',
          ),
          const VillageRecord(
            villageName: 'Tiruchanur',
            lgdCode: '592012',
            gramPanchayat: 'Tiruchanur GP',
            policeStationPostOffice: 'Tirupati PS / PO 517503',
          ),
        ],
        'Madanapalle': [
          const VillageRecord(
            villageName: 'Ankisettipalle',
            lgdCode: '592020',
            gramPanchayat: 'Ankisettipalle GP',
            policeStationPostOffice: 'Madanapalle PS / PO 517325',
          ),
          const VillageRecord(
            villageName: 'Basinikonda',
            lgdCode: '592021',
            gramPanchayat: 'Basinikonda GP',
            policeStationPostOffice: 'Madanapalle PS / PO 517325',
          ),
        ],
      },
      'Guntur': {
        'Guntur Urban': [
          const VillageRecord(
            villageName: 'Gorantla',
            lgdCode: '593001',
            gramPanchayat: 'Gorantla GP',
            policeStationPostOffice: 'Guntur PS / PO 522034',
          ),
          const VillageRecord(
            villageName: 'Nallapadu',
            lgdCode: '593002',
            gramPanchayat: 'Nallapadu GP',
            policeStationPostOffice: 'Guntur PS / PO 522005',
          ),
          const VillageRecord(
            villageName: 'Peda Palakaluru',
            lgdCode: '593003',
            gramPanchayat: 'Peda Palakaluru GP',
            policeStationPostOffice: 'Guntur PS / PO 522009',
          ),
        ],
        'Tenali': [
          const VillageRecord(
            villageName: 'Angalakuduru',
            lgdCode: '593010',
            gramPanchayat: 'Angalakuduru GP',
            policeStationPostOffice: 'Tenali PS / PO 522202',
          ),
          const VillageRecord(
            villageName: 'Pinapadu',
            lgdCode: '593011',
            gramPanchayat: 'Pinapadu GP',
            policeStationPostOffice: 'Tenali PS / PO 522201',
          ),
        ],
        'Mangalagiri': [
          const VillageRecord(
            villageName: 'Atmakur',
            lgdCode: '593020',
            gramPanchayat: 'Atmakur GP',
            policeStationPostOffice: 'Mangalagiri PS / PO 522503',
          ),
          const VillageRecord(
            villageName: 'Navuluru',
            lgdCode: '593021',
            gramPanchayat: 'Navuluru GP',
            policeStationPostOffice: 'Mangalagiri PS / PO 522503',
          ),
        ],
      },
      'Krishna': {
        'Machilipatnam': [
          const VillageRecord(
            villageName: 'Chilakalapudi',
            lgdCode: '594001',
            gramPanchayat: 'Chilakalapudi GP',
            policeStationPostOffice: 'Machilipatnam PS / PO 521002',
          ),
          const VillageRecord(
            villageName: 'Pothepalli',
            lgdCode: '594002',
            gramPanchayat: 'Pothepalli GP',
            policeStationPostOffice: 'Machilipatnam PS / PO 521001',
          ),
        ],
        'Vijayawada': [
          const VillageRecord(
            villageName: 'Kanuru',
            lgdCode: '594010',
            gramPanchayat: 'Kanuru GP',
            policeStationPostOffice: 'Vijayawada PS / PO 520007',
          ),
          const VillageRecord(
            villageName: 'Poranki',
            lgdCode: '594011',
            gramPanchayat: 'Poranki GP',
            policeStationPostOffice: 'Vijayawada PS / PO 521137',
          ),
          const VillageRecord(
            villageName: 'Yanamalakuduru',
            lgdCode: '594012',
            gramPanchayat: 'Yanamalakuduru GP',
            policeStationPostOffice: 'Vijayawada PS / PO 520013',
          ),
        ],
      },
      'Visakhapatnam': {
        'Visakhapatnam Urban': [
          const VillageRecord(
            villageName: 'Madhurawada',
            lgdCode: '595001',
            gramPanchayat: 'Madhurawada GP',
            policeStationPostOffice: 'Visakhapatnam PS / PO 530048',
          ),
          const VillageRecord(
            villageName: 'Gajuwaka Rural',
            lgdCode: '595002',
            gramPanchayat: 'Gajuwaka GP',
            policeStationPostOffice: 'Gajuwaka PS / PO 530026',
          ),
          const VillageRecord(
            villageName: 'Pendurthi',
            lgdCode: '595003',
            gramPanchayat: 'Pendurthi GP',
            policeStationPostOffice: 'Pendurthi PS / PO 531173',
          ),
        ],
        'Anakapalle': [
          const VillageRecord(
            villageName: 'Thummapala',
            lgdCode: '595010',
            gramPanchayat: 'Thummapala GP',
            policeStationPostOffice: 'Anakapalle PS / PO 531001',
          ),
          const VillageRecord(
            villageName: 'Rebaka',
            lgdCode: '595011',
            gramPanchayat: 'Rebaka GP',
            policeStationPostOffice: 'Anakapalle PS / PO 531002',
          ),
        ],
      },
    },
    'Arunachal Pradesh': {
      'Changlang': {
        'Miao': [
          const VillageRecord(
            villageName: 'Miao Town Area',
            lgdCode: '265201',
            gramPanchayat: 'Miao Anchal Samiti',
            policeStationPostOffice: 'Miao PS / PO 792122',
          ),
          const VillageRecord(
            villageName: 'Kharsang',
            lgdCode: '265202',
            gramPanchayat: 'Kharsang Anchal Samiti',
            policeStationPostOffice: 'Kharsang PS / PO 792122',
          ),
        ],
        'Jairampur': [
          const VillageRecord(
            villageName: 'Jairampur Town',
            lgdCode: '265210',
            gramPanchayat: 'Jairampur AS',
            policeStationPostOffice: 'Jairampur PS / PO 792121',
          ),
          const VillageRecord(
            villageName: 'Nampong',
            lgdCode: '265211',
            gramPanchayat: 'Nampong AS',
            policeStationPostOffice: 'Nampong PS / PO 792123',
          ),
        ],
      },
      'Namsai': {
        'Namsai Block': [
          const VillageRecord(
            villageName: 'Namsai Village',
            lgdCode: '265101',
            gramPanchayat: 'Namsai Anchal Samiti',
            policeStationPostOffice: 'Namsai PS / PO 792103',
          ),
          const VillageRecord(
            villageName: 'Chongkham',
            lgdCode: '265102',
            gramPanchayat: 'Chongkham Anchal Samiti',
            policeStationPostOffice: 'Chongkham PS / PO 792102',
          ),
          const VillageRecord(
            villageName: 'Lathao',
            lgdCode: '265103',
            gramPanchayat: 'Lathao Anchal Samiti',
            policeStationPostOffice: 'Namsai PS / PO 792103',
          ),
        ],
        'Mahadevpur': [
          const VillageRecord(
            villageName: 'Mahadevpur I',
            lgdCode: '265110',
            gramPanchayat: 'Mahadevpur AS',
            policeStationPostOffice: 'Mahadevpur PS / PO 792105',
          ),
          const VillageRecord(
            villageName: 'Kakoni',
            lgdCode: '265111',
            gramPanchayat: 'Kakoni AS',
            policeStationPostOffice: 'Mahadevpur PS / PO 792105',
          ),
        ],
      },
      'Papum Pare': {
        'Itanagar': [
          const VillageRecord(
            villageName: 'Ganga Village',
            lgdCode: '265301',
            gramPanchayat: 'Ganga AS',
            policeStationPostOffice: 'Itanagar PS / PO 791111',
          ),
          const VillageRecord(
            villageName: 'Chimpu',
            lgdCode: '265302',
            gramPanchayat: 'Chimpu AS',
            policeStationPostOffice: 'Itanagar PS / PO 791113',
          ),
        ],
        'Naharlagun': [
          const VillageRecord(
            villageName: 'Nirjuli',
            lgdCode: '265310',
            gramPanchayat: 'Nirjuli AS',
            policeStationPostOffice: 'Naharlagun PS / PO 791109',
          ),
          const VillageRecord(
            villageName: 'Doimukh Village',
            lgdCode: '265311',
            gramPanchayat: 'Doimukh AS',
            policeStationPostOffice: 'Doimukh PS / PO 791112',
          ),
        ],
      },
      'Tawang': {
        'Tawang Block': [
          const VillageRecord(
            villageName: 'Lhou Village',
            lgdCode: '265401',
            gramPanchayat: 'Lhou AS',
            policeStationPostOffice: 'Tawang PS / PO 790104',
          ),
          const VillageRecord(
            villageName: 'Kitpi',
            lgdCode: '265402',
            gramPanchayat: 'Kitpi AS',
            policeStationPostOffice: 'Tawang PS / PO 790104',
          ),
        ],
        'Jang': [
          const VillageRecord(
            villageName: 'Jang Town',
            lgdCode: '265410',
            gramPanchayat: 'Jang AS',
            policeStationPostOffice: 'Jang PS / PO 790105',
          ),
        ],
      },
    },
    'Assam': {
      'Cachar': {
        'Silchar': [
          const VillageRecord(
            villageName: 'Tarapur',
            lgdCode: '284001',
            gramPanchayat: 'Tarapur GP',
            policeStationPostOffice: 'Silchar PS / PO 788001',
          ),
          const VillageRecord(
            villageName: 'Meherpur',
            lgdCode: '284002',
            gramPanchayat: 'Meherpur GP',
            policeStationPostOffice: 'Silchar PS / PO 788015',
          ),
          const VillageRecord(
            villageName: 'Ambikapur',
            lgdCode: '284003',
            gramPanchayat: 'Ambikapur GP',
            policeStationPostOffice: 'Silchar PS / PO 788005',
          ),
        ],
        'Lakhipur': [
          const VillageRecord(
            villageName: 'Lakhipur Gaon',
            lgdCode: '284010',
            gramPanchayat: 'Lakhipur GP',
            policeStationPostOffice: 'Lakhipur PS / PO 788103',
          ),
        ],
      },
      'Kamrup Metropolitan': {
        'Guwahati': [
          const VillageRecord(
            villageName: 'Dispur',
            lgdCode: '284101',
            gramPanchayat: 'Dispur Ward 10',
            policeStationPostOffice: 'Dispur PS / PO 781006',
          ),
          const VillageRecord(
            villageName: 'Khanapara',
            lgdCode: '284102',
            gramPanchayat: 'Khanapara GP',
            policeStationPostOffice: 'Khanapara PS / PO 781022',
          ),
          const VillageRecord(
            villageName: 'Borjhar',
            lgdCode: '284103',
            gramPanchayat: 'Borjhar GP',
            policeStationPostOffice: 'Azara PS / PO 781015',
          ),
        ],
        'North Guwahati': [
          const VillageRecord(
            villageName: 'Amingaon',
            lgdCode: '284110',
            gramPanchayat: 'Amingaon GP',
            policeStationPostOffice: 'North Guwahati PS / PO 781031',
          ),
        ],
      },
      'Dibrugarh': {
        'Dibrugarh Urban': [
          const VillageRecord(
            villageName: 'Barbari',
            lgdCode: '284201',
            gramPanchayat: 'Barbari GP',
            policeStationPostOffice: 'Dibrugarh PS / PO 786001',
          ),
          const VillageRecord(
            villageName: 'Chowkidinghee',
            lgdCode: '284202',
            gramPanchayat: 'Chowkidinghee GP',
            policeStationPostOffice: 'Dibrugarh PS / PO 786003',
          ),
        ],
        'Moran': [
          const VillageRecord(
            villageName: 'Moran Gaon',
            lgdCode: '284210',
            gramPanchayat: 'Moran GP',
            policeStationPostOffice: 'Moranhat PS / PO 785670',
          ),
        ],
      },
      'Jorhat': {
        'Jorhat Urban': [
          const VillageRecord(
            villageName: 'Rowriah',
            lgdCode: '284301',
            gramPanchayat: 'Rowriah GP',
            policeStationPostOffice: 'Jorhat PS / PO 785004',
          ),
          const VillageRecord(
            villageName: 'Garmur',
            lgdCode: '284302',
            gramPanchayat: 'Garmur GP',
            policeStationPostOffice: 'Jorhat PS / PO 785007',
          ),
        ],
        'Titabor': [
          const VillageRecord(
            villageName: 'Titabor Gaon',
            lgdCode: '284310',
            gramPanchayat: 'Titabor GP',
            policeStationPostOffice: 'Titabor PS / PO 785630',
          ),
        ],
      },
    },
    'Bihar': {
      'Patna': {
        'Patna Sadar': [
          const VillageRecord(
            villageName: 'Digha',
            lgdCode: '211001',
            gramPanchayat: 'Digha Panchayat',
            policeStationPostOffice: 'Digha PS / PO 800011',
          ),
          const VillageRecord(
            villageName: 'Phulwari Sharif',
            lgdCode: '211002',
            gramPanchayat: 'Phulwari GP',
            policeStationPostOffice: 'Phulwari PS / PO 801505',
          ),
          const VillageRecord(
            villageName: 'Danapur Cantt',
            lgdCode: '211003',
            gramPanchayat: 'Danapur GP',
            policeStationPostOffice: 'Danapur PS / PO 801503',
          ),
        ],
        'Barh': [
          const VillageRecord(
            villageName: 'Bakhtiyarpur Rural',
            lgdCode: '211010',
            gramPanchayat: 'Bakhtiyarpur GP',
            policeStationPostOffice: 'Bakhtiyarpur PS / PO 803212',
          ),
          const VillageRecord(
            villageName: 'Mokama Rural',
            lgdCode: '211011',
            gramPanchayat: 'Mokama GP',
            policeStationPostOffice: 'Mokama PS / PO 803302',
          ),
        ],
      },
      'Gaya': {
        'Gaya Town': [
          const VillageRecord(
            villageName: 'Bodh Gaya',
            lgdCode: '212001',
            gramPanchayat: 'Bodh Gaya Nagar',
            policeStationPostOffice: 'Bodh Gaya PS / PO 824231',
          ),
          const VillageRecord(
            villageName: 'Manpur',
            lgdCode: '212002',
            gramPanchayat: 'Manpur GP',
            policeStationPostOffice: 'Mufassil PS / PO 823003',
          ),
        ],
        'Sherghati': [
          const VillageRecord(
            villageName: 'Sherghati Bazar',
            lgdCode: '212010',
            gramPanchayat: 'Sherghati GP',
            policeStationPostOffice: 'Sherghati PS / PO 824211',
          ),
        ],
      },
      'Muzaffarpur': {
        'Muzaffarpur East': [
          const VillageRecord(
            villageName: 'Bochahan',
            lgdCode: '213001',
            gramPanchayat: 'Bochahan GP',
            policeStationPostOffice: 'Bochahan PS / PO 843103',
          ),
          const VillageRecord(
            villageName: 'Mushahari',
            lgdCode: '213002',
            gramPanchayat: 'Mushahari GP',
            policeStationPostOffice: 'Mushahari PS / PO 842002',
          ),
        ],
        'Muzaffarpur West': [
          const VillageRecord(
            villageName: 'Kanti Rural',
            lgdCode: '213010',
            gramPanchayat: 'Kanti GP',
            policeStationPostOffice: 'Kanti PS / PO 843109',
          ),
          const VillageRecord(
            villageName: 'Motipur',
            lgdCode: '213011',
            gramPanchayat: 'Motipur GP',
            policeStationPostOffice: 'Motipur PS / PO 843111',
          ),
        ],
      },
      'Bhagalpur': {
        'Bhagalpur Sadar': [
          const VillageRecord(
            villageName: 'Sabour',
            lgdCode: '214001',
            gramPanchayat: 'Sabour GP',
            policeStationPostOffice: 'Sabour PS / PO 813210',
          ),
          const VillageRecord(
            villageName: 'Nathnagar',
            lgdCode: '214002',
            gramPanchayat: 'Nathnagar GP',
            policeStationPostOffice: 'Nathnagar PS / PO 812006',
          ),
        ],
        'Kahalgaon': [
          const VillageRecord(
            villageName: 'Colgong Rural',
            lgdCode: '214010',
            gramPanchayat: 'Kahalgaon GP',
            policeStationPostOffice: 'Kahalgaon PS / PO 813203',
          ),
        ],
      },
    },
    'Chhattisgarh': {
      'Raipur': {
        'Raipur Urban': [
          const VillageRecord(
            villageName: 'Mana Camp',
            lgdCode: '401001',
            gramPanchayat: 'Mana GP',
            policeStationPostOffice: 'Mana PS / PO 492015',
          ),
          const VillageRecord(
            villageName: 'Mandir Hasaud',
            lgdCode: '401002',
            gramPanchayat: 'Mandir Hasaud GP',
            policeStationPostOffice: 'Mandir Hasaud PS / PO 492101',
          ),
        ],
        'Arang': [
          const VillageRecord(
            villageName: 'Arang Rural',
            lgdCode: '401010',
            gramPanchayat: 'Arang GP',
            policeStationPostOffice: 'Arang PS / PO 493441',
          ),
          const VillageRecord(
            villageName: 'Gullu',
            lgdCode: '401011',
            gramPanchayat: 'Gullu GP',
            policeStationPostOffice: 'Arang PS / PO 493441',
          ),
        ],
      },
      'Bilaspur': {
        'Bilaspur City': [
          const VillageRecord(
            villageName: 'Tifra',
            lgdCode: '402001',
            gramPanchayat: 'Tifra GP',
            policeStationPostOffice: 'Sirgitti PS / PO 495223',
          ),
          const VillageRecord(
            villageName: 'Koni',
            lgdCode: '402002',
            gramPanchayat: 'Koni GP',
            policeStationPostOffice: 'Koni PS / PO 495009',
          ),
        ],
        'Kota': [
          const VillageRecord(
            villageName: 'Kota Town',
            lgdCode: '402010',
            gramPanchayat: 'Kota GP',
            policeStationPostOffice: 'Kota PS / PO 495113',
          ),
          const VillageRecord(
            villageName: 'Ratanpur',
            lgdCode: '402011',
            gramPanchayat: 'Ratanpur GP',
            policeStationPostOffice: 'Ratanpur PS / PO 495442',
          ),
        ],
      },
      'Durg': {
        'Bhilai': [
          const VillageRecord(
            villageName: 'Kumhari',
            lgdCode: '403001',
            gramPanchayat: 'Kumhari GP',
            policeStationPostOffice: 'Kumhari PS / PO 490042',
          ),
          const VillageRecord(
            villageName: 'Jamul',
            lgdCode: '403002',
            gramPanchayat: 'Jamul GP',
            policeStationPostOffice: 'Jamul PS / PO 490024',
          ),
        ],
        'Durg Sadar': [
          const VillageRecord(
            villageName: 'Patan Rural',
            lgdCode: '403010',
            gramPanchayat: 'Patan GP',
            policeStationPostOffice: 'Patan PS / PO 491111',
          ),
        ],
      },
    },
    'Goa': {
      'North Goa': {
        'Panaji': [
          const VillageRecord(
            villageName: 'Miramar',
            lgdCode: '301001',
            gramPanchayat: 'Panaji Ward 5',
            policeStationPostOffice: 'Panaji PS / PO 403001',
          ),
          const VillageRecord(
            villageName: 'Taleigao',
            lgdCode: '301002',
            gramPanchayat: 'Taleigao GP',
            policeStationPostOffice: 'Panaji PS / PO 403002',
          ),
          const VillageRecord(
            villageName: 'Santa Cruz',
            lgdCode: '301003',
            gramPanchayat: 'Santa Cruz GP',
            policeStationPostOffice: 'Old Goa PS / PO 403005',
          ),
        ],
        'Mapusa': [
          const VillageRecord(
            villageName: 'Calangute',
            lgdCode: '301010',
            gramPanchayat: 'Calangute GP',
            policeStationPostOffice: 'Calangute PS / PO 403516',
          ),
          const VillageRecord(
            villageName: 'Candolim',
            lgdCode: '301011',
            gramPanchayat: 'Candolim GP',
            policeStationPostOffice: 'Calangute PS / PO 403515',
          ),
          const VillageRecord(
            villageName: 'Anjuna',
            lgdCode: '301012',
            gramPanchayat: 'Anjuna GP',
            policeStationPostOffice: 'Anjuna PS / PO 403509',
          ),
        ],
      },
      'South Goa': {
        'Margao': [
          const VillageRecord(
            villageName: 'Benaulim',
            lgdCode: '302001',
            gramPanchayat: 'Benaulim GP',
            policeStationPostOffice: 'Colva PS / PO 403716',
          ),
          const VillageRecord(
            villageName: 'Colva',
            lgdCode: '302002',
            gramPanchayat: 'Colva GP',
            policeStationPostOffice: 'Colva PS / PO 403708',
          ),
          const VillageRecord(
            villageName: 'Navelim',
            lgdCode: '302003',
            gramPanchayat: 'Navelim GP',
            policeStationPostOffice: 'Margao PS / PO 403707',
          ),
        ],
        'Mormugao': [
          const VillageRecord(
            villageName: 'Chicalim',
            lgdCode: '302010',
            gramPanchayat: 'Chicalim GP',
            policeStationPostOffice: 'Vasco PS / PO 403711',
          ),
          const VillageRecord(
            villageName: 'Bogmalo',
            lgdCode: '302011',
            gramPanchayat: 'Bogmalo GP',
            policeStationPostOffice: 'Vasco PS / PO 403806',
          ),
        ],
      },
    },
    'Gujarat': {
      'Ahmedabad': {
        'Ahmedabad City': [
          const VillageRecord(
            villageName: 'Bopal',
            lgdCode: '501001',
            gramPanchayat: 'Bopal GP',
            policeStationPostOffice: 'Bopal PS / PO 380058',
          ),
          const VillageRecord(
            villageName: 'Gota',
            lgdCode: '501002',
            gramPanchayat: 'Gota Ward',
            policeStationPostOffice: 'Sola PS / PO 382481',
          ),
          const VillageRecord(
            villageName: 'Chandkheda',
            lgdCode: '501003',
            gramPanchayat: 'Chandkheda GP',
            policeStationPostOffice: 'Chandkheda PS / PO 382424',
          ),
        ],
        'Sanand': [
          const VillageRecord(
            villageName: 'Sanand Rural',
            lgdCode: '501010',
            gramPanchayat: 'Sanand GP',
            policeStationPostOffice: 'Sanand PS / PO 382110',
          ),
          const VillageRecord(
            villageName: 'Changodar',
            lgdCode: '501011',
            gramPanchayat: 'Changodar GP',
            policeStationPostOffice: 'Changodar PS / PO 382213',
          ),
        ],
      },
      'Surat': {
        'Surat City': [
          const VillageRecord(
            villageName: 'Adajan',
            lgdCode: '502001',
            gramPanchayat: 'Adajan Ward',
            policeStationPostOffice: 'Adajan PS / PO 395009',
          ),
          const VillageRecord(
            villageName: 'Vesu',
            lgdCode: '502002',
            gramPanchayat: 'Vesu GP',
            policeStationPostOffice: 'Umra PS / PO 395007',
          ),
          const VillageRecord(
            villageName: 'Katargam',
            lgdCode: '502003',
            gramPanchayat: 'Katargam Ward',
            policeStationPostOffice: 'Katargam PS / PO 395004',
          ),
        ],
        'Olpad': [
          const VillageRecord(
            villageName: 'Olpad Rural',
            lgdCode: '502010',
            gramPanchayat: 'Olpad GP',
            policeStationPostOffice: 'Olpad PS / PO 394540',
          ),
        ],
      },
      'Vadodara': {
        'Vadodara City': [
          const VillageRecord(
            villageName: 'Alkapuri',
            lgdCode: '503001',
            gramPanchayat: 'Alkapuri Ward',
            policeStationPostOffice: 'Sayajiganj PS / PO 390007',
          ),
          const VillageRecord(
            villageName: 'Waghodia Rural',
            lgdCode: '503002',
            gramPanchayat: 'Waghodia GP',
            policeStationPostOffice: 'Waghodia PS / PO 391760',
          ),
        ],
        'Padra': [
          const VillageRecord(
            villageName: 'Padra Gam',
            lgdCode: '503010',
            gramPanchayat: 'Padra GP',
            policeStationPostOffice: 'Padra PS / PO 391440',
          ),
        ],
      },
      'Rajkot': {
        'Rajkot City': [
          const VillageRecord(
            villageName: 'Kothariya',
            lgdCode: '504001',
            gramPanchayat: 'Kothariya GP',
            policeStationPostOffice: 'Bhakti Nagar PS / PO 360022',
          ),
          const VillageRecord(
            villageName: 'Madhapar',
            lgdCode: '504002',
            gramPanchayat: 'Madhapar GP',
            policeStationPostOffice: 'Gandhigram PS / PO 360006',
          ),
        ],
        'Gondal': [
          const VillageRecord(
            villageName: 'Gondal Rural',
            lgdCode: '504010',
            gramPanchayat: 'Gondal GP',
            policeStationPostOffice: 'Gondal PS / PO 360311',
          ),
        ],
      },
    },
    'Haryana': {
      'Gurugram': {
        'Gurugram Urban': [
          const VillageRecord(
            villageName: 'Wazirabad',
            lgdCode: '101001',
            gramPanchayat: 'Wazirabad GP',
            policeStationPostOffice: 'Sector 56 PS / PO 122003',
          ),
          const VillageRecord(
            villageName: 'Sikanderpur',
            lgdCode: '101002',
            gramPanchayat: 'Sikanderpur GP',
            policeStationPostOffice: 'DLF Phase 2 PS / PO 122002',
          ),
          const VillageRecord(
            villageName: 'Badshahpur',
            lgdCode: '101003',
            gramPanchayat: 'Badshahpur GP',
            policeStationPostOffice: 'Badshahpur PS / PO 122101',
          ),
        ],
        'Manesar': [
          const VillageRecord(
            villageName: 'Kasan',
            lgdCode: '101010',
            gramPanchayat: 'Kasan GP',
            policeStationPostOffice: 'Manesar PS / PO 122051',
          ),
          const VillageRecord(
            villageName: 'Nakhrola',
            lgdCode: '101011',
            gramPanchayat: 'Nakhrola GP',
            policeStationPostOffice: 'Manesar PS / PO 122004',
          ),
        ],
      },
      'Faridabad': {
        'Faridabad Urban': [
          const VillageRecord(
            villageName: 'Ballabgarh',
            lgdCode: '102001',
            gramPanchayat: 'Ballabgarh Ward',
            policeStationPostOffice: 'Ballabgarh PS / PO 121004',
          ),
          const VillageRecord(
            villageName: 'Tigaon',
            lgdCode: '102002',
            gramPanchayat: 'Tigaon GP',
            policeStationPostOffice: 'Tigaon PS / PO 121101',
          ),
        ],
        'Badkhal': [
          const VillageRecord(
            villageName: 'Ankhir',
            lgdCode: '102010',
            gramPanchayat: 'Ankhir GP',
            policeStationPostOffice: 'Badkhal PS / PO 121001',
          ),
        ],
      },
      'Hisar': {
        'Hisar Sadar': [
          const VillageRecord(
            villageName: 'Satrod',
            lgdCode: '103001',
            gramPanchayat: 'Satrod GP',
            policeStationPostOffice: 'Hisar Cantt PS / PO 125006',
          ),
          const VillageRecord(
            villageName: 'Mangali',
            lgdCode: '103002',
            gramPanchayat: 'Mangali GP',
            policeStationPostOffice: 'Hisar Sadar PS / PO 125001',
          ),
        ],
        'Hansi': [
          const VillageRecord(
            villageName: 'Hansi Rural',
            lgdCode: '103010',
            gramPanchayat: 'Hansi GP',
            policeStationPostOffice: 'Hansi City PS / PO 125033',
          ),
        ],
      },
      'Ambala': {
        'Ambala City': [
          const VillageRecord(
            villageName: 'Jandli',
            lgdCode: '104001',
            gramPanchayat: 'Jandli GP',
            policeStationPostOffice: 'Ambala City PS / PO 134003',
          ),
          const VillageRecord(
            villageName: 'Khurd',
            lgdCode: '104002',
            gramPanchayat: 'Khurd GP',
            policeStationPostOffice: 'Ambala City PS / PO 134002',
          ),
        ],
      },
    },
    'Himachal Pradesh': {
      'Shimla': {
        'Shimla Urban': [
          const VillageRecord(
            villageName: 'Kasumpti',
            lgdCode: '111001',
            gramPanchayat: 'Kasumpti Ward',
            policeStationPostOffice: 'Kasumpti PS / PO 171009',
          ),
          const VillageRecord(
            villageName: 'Sanjauli',
            lgdCode: '111002',
            gramPanchayat: 'Sanjauli Ward',
            policeStationPostOffice: 'Dhalli PS / PO 171006',
          ),
          const VillageRecord(
            villageName: 'Totu',
            lgdCode: '111003',
            gramPanchayat: 'Totu GP',
            policeStationPostOffice: 'Boileauganj PS / PO 171011',
          ),
        ],
        'Theog': [
          const VillageRecord(
            villageName: 'Theog Rural',
            lgdCode: '111010',
            gramPanchayat: 'Theog GP',
            policeStationPostOffice: 'Theog PS / PO 171201',
          ),
        ],
      },
      'Kangra': {
        'Dharamshala': [
          const VillageRecord(
            villageName: 'McLeod Ganj',
            lgdCode: '112001',
            gramPanchayat: 'McLeod Ganj Ward',
            policeStationPostOffice: 'McLeod Ganj PS / PO 176219',
          ),
          const VillageRecord(
            villageName: 'Forsyth Ganj',
            lgdCode: '112002',
            gramPanchayat: 'Forsyth Ganj GP',
            policeStationPostOffice: 'Dharamshala PS / PO 176215',
          ),
          const VillageRecord(
            villageName: 'Yol Cantt',
            lgdCode: '112003',
            gramPanchayat: 'Yol GP',
            policeStationPostOffice: 'Yol PS / PO 176052',
          ),
        ],
        'Palampur': [
          const VillageRecord(
            villageName: 'Bundla',
            lgdCode: '112010',
            gramPanchayat: 'Bundla GP',
            policeStationPostOffice: 'Palampur PS / PO 176061',
          ),
          const VillageRecord(
            villageName: 'Maranda',
            lgdCode: '112011',
            gramPanchayat: 'Maranda GP',
            policeStationPostOffice: 'Palampur PS / PO 176102',
          ),
        ],
      },
      'Kullu': {
        'Kullu Sadar': [
          const VillageRecord(
            villageName: 'Dhalpur',
            lgdCode: '113001',
            gramPanchayat: 'Dhalpur GP',
            policeStationPostOffice: 'Kullu PS / PO 175101',
          ),
          const VillageRecord(
            villageName: 'Bajaura',
            lgdCode: '113002',
            gramPanchayat: 'Bajaura GP',
            policeStationPostOffice: 'Bajaura PS / PO 175125',
          ),
        ],
        'Manali': [
          const VillageRecord(
            villageName: 'Vashisht',
            lgdCode: '113010',
            gramPanchayat: 'Vashisht GP',
            policeStationPostOffice: 'Manali PS / PO 175131',
          ),
          const VillageRecord(
            villageName: 'Solang',
            lgdCode: '113011',
            gramPanchayat: 'Solang GP',
            policeStationPostOffice: 'Manali PS / PO 175131',
          ),
        ],
      },
    },
    'Jharkhand': {
      'Ranchi': {
        'Ranchi Urban': [
          const VillageRecord(
            villageName: 'Morabadi',
            lgdCode: '201001',
            gramPanchayat: 'Morabadi Ward',
            policeStationPostOffice: 'Bariatu PS / PO 834008',
          ),
          const VillageRecord(
            villageName: 'Doranda',
            lgdCode: '201002',
            gramPanchayat: 'Doranda Ward',
            policeStationPostOffice: 'Doranda PS / PO 834002',
          ),
          const VillageRecord(
            villageName: 'Hatia',
            lgdCode: '201003',
            gramPanchayat: 'Hatia GP',
            policeStationPostOffice: 'Hatia PS / PO 834003',
          ),
        ],
        'Kanke': [
          const VillageRecord(
            villageName: 'Kanke Village',
            lgdCode: '201010',
            gramPanchayat: 'Kanke GP',
            policeStationPostOffice: 'Kanke PS / PO 834006',
          ),
          const VillageRecord(
            villageName: 'Arsande',
            lgdCode: '201011',
            gramPanchayat: 'Arsande GP',
            policeStationPostOffice: 'Kanke PS / PO 834006',
          ),
        ],
      },
      'East Singhbhum': {
        'Jamshedpur': [
          const VillageRecord(
            villageName: 'Bistupur',
            lgdCode: '202001',
            gramPanchayat: 'Bistupur Ward',
            policeStationPostOffice: 'Bistupur PS / PO 831001',
          ),
          const VillageRecord(
            villageName: 'Kadma',
            lgdCode: '202002',
            gramPanchayat: 'Kadma Ward',
            policeStationPostOffice: 'Kadma PS / PO 831005',
          ),
          const VillageRecord(
            villageName: 'Mango',
            lgdCode: '202003',
            gramPanchayat: 'Mango GP',
            policeStationPostOffice: 'Mango PS / PO 831012',
          ),
        ],
        'Ghatshila': [
          const VillageRecord(
            villageName: 'Ghatshila Rural',
            lgdCode: '202010',
            gramPanchayat: 'Ghatshila GP',
            policeStationPostOffice: 'Ghatshila PS / PO 832303',
          ),
        ],
      },
      'Dhanbad': {
        'Dhanbad Sadar': [
          const VillageRecord(
            villageName: 'Jharia',
            lgdCode: '203001',
            gramPanchayat: 'Jharia Ward',
            policeStationPostOffice: 'Jharia PS / PO 828111',
          ),
          const VillageRecord(
            villageName: 'Katras',
            lgdCode: '203002',
            gramPanchayat: 'Katras GP',
            policeStationPostOffice: 'Katras PS / PO 828113',
          ),
        ],
      },
    },
    'Karnataka': {
      'Bengaluru Urban': {
        'Bengaluru North': [
          const VillageRecord(
            villageName: 'Yelahanka',
            lgdCode: '581001',
            gramPanchayat: 'Yelahanka Ward',
            policeStationPostOffice: 'Yelahanka PS / PO 560064',
          ),
          const VillageRecord(
            villageName: 'Hebbal',
            lgdCode: '581002',
            gramPanchayat: 'Hebbal Ward',
            policeStationPostOffice: 'Hebbal PS / PO 560024',
          ),
          const VillageRecord(
            villageName: 'Jalahalli',
            lgdCode: '581003',
            gramPanchayat: 'Jalahalli Ward',
            policeStationPostOffice: 'Jalahalli PS / PO 560013',
          ),
        ],
        'Bengaluru South': [
          const VillageRecord(
            villageName: 'Electronic City',
            lgdCode: '581010',
            gramPanchayat: 'Doddathoguru GP',
            policeStationPostOffice: 'Electronic City PS / PO 560100',
          ),
          const VillageRecord(
            villageName: 'Bannerghatta',
            lgdCode: '581011',
            gramPanchayat: 'Bannerghatta GP',
            policeStationPostOffice: 'Bannerghatta PS / PO 560083',
          ),
          const VillageRecord(
            villageName: 'Kengeri',
            lgdCode: '581012',
            gramPanchayat: 'Kengeri Ward',
            policeStationPostOffice: 'Kengeri PS / PO 560060',
          ),
        ],
        'Anekal': [
          const VillageRecord(
            villageName: 'Attibele',
            lgdCode: '581020',
            gramPanchayat: 'Attibele GP',
            policeStationPostOffice: 'Attibele PS / PO 562107',
          ),
          const VillageRecord(
            villageName: 'Chandapura',
            lgdCode: '581021',
            gramPanchayat: 'Chandapura GP',
            policeStationPostOffice: 'Anekal PS / PO 560099',
          ),
        ],
      },
      'Mysuru': {
        'Mysuru City': [
          const VillageRecord(
            villageName: 'Chamundi Hill',
            lgdCode: '582001',
            gramPanchayat: 'Chamundi Hill GP',
            policeStationPostOffice: 'Siddartha Nagar PS / PO 570010',
          ),
          const VillageRecord(
            villageName: 'Hootagalli',
            lgdCode: '582002',
            gramPanchayat: 'Hootagalli GP',
            policeStationPostOffice: 'Vijayanagar PS / PO 570018',
          ),
          const VillageRecord(
            villageName: 'Bannimantap',
            lgdCode: '582003',
            gramPanchayat: 'Bannimantap Ward',
            policeStationPostOffice: 'Narasimharaja PS / PO 570015',
          ),
        ],
        'Nanjangud': [
          const VillageRecord(
            villageName: 'Nanjangud Rural',
            lgdCode: '582010',
            gramPanchayat: 'Nanjangud GP',
            policeStationPostOffice: 'Nanjangud PS / PO 571301',
          ),
        ],
      },
      'Dakshina Kannada': {
        'Mangaluru': [
          const VillageRecord(
            villageName: 'Surathkal',
            lgdCode: '583001',
            gramPanchayat: 'Surathkal Ward',
            policeStationPostOffice: 'Surathkal PS / PO 575014',
          ),
          const VillageRecord(
            villageName: 'Panambur',
            lgdCode: '583002',
            gramPanchayat: 'Panambur Ward',
            policeStationPostOffice: 'Panambur PS / PO 575010',
          ),
          const VillageRecord(
            villageName: 'Ullal',
            lgdCode: '583003',
            gramPanchayat: 'Ullal GP',
            policeStationPostOffice: 'Ullal PS / PO 575020',
          ),
        ],
        'Bantwal': [
          const VillageRecord(
            villageName: 'BC Road',
            lgdCode: '583010',
            gramPanchayat: 'Bantwal GP',
            policeStationPostOffice: 'Bantwal PS / PO 574211',
          ),
        ],
      },
      'Belagavi': {
        'Belagavi City': [
          const VillageRecord(
            villageName: 'Peeranwadi',
            lgdCode: '584001',
            gramPanchayat: 'Peeranwadi GP',
            policeStationPostOffice: 'Udyambag PS / PO 590008',
          ),
          const VillageRecord(
            villageName: 'Kakati',
            lgdCode: '584002',
            gramPanchayat: 'Kakati GP',
            policeStationPostOffice: 'Kakati PS / PO 591113',
          ),
        ],
        'Gokak': [
          const VillageRecord(
            villageName: 'Gokak Falls',
            lgdCode: '584010',
            gramPanchayat: 'Gokak Falls GP',
            policeStationPostOffice: 'Gokak PS / PO 591307',
          ),
        ],
      },
    },
    'Kerala': {
      'Thiruvananthapuram': {
        'Thiruvananthapuram Urban': [
          const VillageRecord(
            villageName: 'Kowdiar',
            lgdCode: '601001',
            gramPanchayat: 'Kowdiar Ward',
            policeStationPostOffice: 'Museum PS / PO 695003',
          ),
          const VillageRecord(
            villageName: 'Pattom',
            lgdCode: '601002',
            gramPanchayat: 'Pattom Ward',
            policeStationPostOffice: 'Medical College PS / PO 695004',
          ),
          const VillageRecord(
            villageName: 'Kazhakkoottam',
            lgdCode: '601003',
            gramPanchayat: 'Kazhakkoottam Ward',
            policeStationPostOffice: 'Kazhakkoottam PS / PO 695582',
          ),
        ],
        'Neyyattinkara': [
          const VillageRecord(
            villageName: 'Vizhinjam',
            lgdCode: '601010',
            gramPanchayat: 'Vizhinjam GP',
            policeStationPostOffice: 'Vizhinjam PS / PO 695521',
          ),
          const VillageRecord(
            villageName: 'Balaramapuram',
            lgdCode: '601011',
            gramPanchayat: 'Balaramapuram GP',
            policeStationPostOffice: 'Balaramapuram PS / PO 695501',
          ),
        ],
      },
      'Ernakulam': {
        'Kochi': [
          const VillageRecord(
            villageName: 'Edappally',
            lgdCode: '602001',
            gramPanchayat: 'Edappally Ward',
            policeStationPostOffice: 'Elamakkara PS / PO 682024',
          ),
          const VillageRecord(
            villageName: 'Kakkanad',
            lgdCode: '602002',
            gramPanchayat: 'Thrikkakara GP',
            policeStationPostOffice: 'Infopark PS / PO 682030',
          ),
          const VillageRecord(
            villageName: 'Fort Kochi',
            lgdCode: '602003',
            gramPanchayat: 'Fort Kochi Ward',
            policeStationPostOffice: 'Fort Kochi PS / PO 682001',
          ),
        ],
        'Aluva': [
          const VillageRecord(
            villageName: 'Angamaly',
            lgdCode: '602010',
            gramPanchayat: 'Angamaly GP',
            policeStationPostOffice: 'Angamaly PS / PO 683572',
          ),
          const VillageRecord(
            villageName: 'Nedumbassery',
            lgdCode: '602011',
            gramPanchayat: 'Nedumbassery GP',
            policeStationPostOffice: 'Nedumbassery PS / PO 683585',
          ),
        ],
      },
      'Kozhikode': {
        'Kozhikode City': [
          const VillageRecord(
            villageName: 'Beypore',
            lgdCode: '603001',
            gramPanchayat: 'Beypore Ward',
            policeStationPostOffice: 'Beypore PS / PO 673015',
          ),
          const VillageRecord(
            villageName: 'Elathur',
            lgdCode: '603002',
            gramPanchayat: 'Elathur GP',
            policeStationPostOffice: 'Elathur PS / PO 673303',
          ),
        ],
        'Vadakara': [
          const VillageRecord(
            villageName: 'Chorode',
            lgdCode: '603010',
            gramPanchayat: 'Chorode GP',
            policeStationPostOffice: 'Vadakara PS / PO 673106',
          ),
        ],
      },
    },
    'Madhya Pradesh': {
      'Bhopal': {
        'Bhopal Urban': [
          const VillageRecord(
            villageName: 'Bairagarh',
            lgdCode: '461001',
            gramPanchayat: 'Bairagarh Ward',
            policeStationPostOffice: 'Bairagarh PS / PO 462030',
          ),
          const VillageRecord(
            villageName: 'Kolar Road',
            lgdCode: '461002',
            gramPanchayat: 'Kolar GP',
            policeStationPostOffice: 'Kolar PS / PO 462042',
          ),
          const VillageRecord(
            villageName: 'Berasia',
            lgdCode: '461003',
            gramPanchayat: 'Berasia GP',
            policeStationPostOffice: 'Berasia PS / PO 463106',
          ),
        ],
      },
      'Indore': {
        'Indore Urban': [
          const VillageRecord(
            villageName: 'Rau',
            lgdCode: '462001',
            gramPanchayat: 'Rau GP',
            policeStationPostOffice: 'Rau PS / PO 453331',
          ),
          const VillageRecord(
            villageName: 'Mhow',
            lgdCode: '462002',
            gramPanchayat: 'Dr. Ambedkar Nagar Cantt',
            policeStationPostOffice: 'Mhow PS / PO 453441',
          ),
          const VillageRecord(
            villageName: 'Sanwer',
            lgdCode: '462003',
            gramPanchayat: 'Sanwer GP',
            policeStationPostOffice: 'Sanwer PS / PO 453551',
          ),
        ],
      },
      'Gwalior': {
        'Gwalior City': [
          const VillageRecord(
            villageName: 'Morar',
            lgdCode: '463001',
            gramPanchayat: 'Morar Ward',
            policeStationPostOffice: 'Morar PS / PO 474006',
          ),
          const VillageRecord(
            villageName: 'Dabra',
            lgdCode: '463002',
            gramPanchayat: 'Dabra GP',
            policeStationPostOffice: 'Dabra PS / PO 475110',
          ),
        ],
      },
      'Jabalpur': {
        'Jabalpur City': [
          const VillageRecord(
            villageName: 'Khamaria',
            lgdCode: '464001',
            gramPanchayat: 'Khamaria GP',
            policeStationPostOffice: 'Khamaria PS / PO 482005',
          ),
          const VillageRecord(
            villageName: 'Bhedaghat',
            lgdCode: '464002',
            gramPanchayat: 'Bhedaghat GP',
            policeStationPostOffice: 'Bhedaghat PS / PO 482003',
          ),
        ],
      },
    },
    'Maharashtra': {
      'Mumbai City': {
        'South Mumbai': [
          const VillageRecord(
            villageName: 'Colaba',
            lgdCode: '400001',
            gramPanchayat: 'Ward A',
            policeStationPostOffice: 'Colaba PS / PO 400005',
          ),
          const VillageRecord(
            villageName: 'Marine Lines',
            lgdCode: '400002',
            gramPanchayat: 'Ward C',
            policeStationPostOffice: 'Marine Drive PS / PO 400020',
          ),
          const VillageRecord(
            villageName: 'Byculla',
            lgdCode: '400003',
            gramPanchayat: 'Ward E',
            policeStationPostOffice: 'Byculla PS / PO 400008',
          ),
        ],
      },
      'Mumbai Suburban': {
        'Western Suburbs': [
          const VillageRecord(
            villageName: 'Andheri West',
            lgdCode: '400010',
            gramPanchayat: 'Ward K-West',
            policeStationPostOffice: 'DN Nagar PS / PO 400058',
          ),
          const VillageRecord(
            villageName: 'Bandra West',
            lgdCode: '400011',
            gramPanchayat: 'Ward H-West',
            policeStationPostOffice: 'Bandra PS / PO 400050',
          ),
          const VillageRecord(
            villageName: 'Borivali West',
            lgdCode: '400012',
            gramPanchayat: 'Ward R-Central',
            policeStationPostOffice: 'Borivali PS / PO 400092',
          ),
        ],
        'Eastern Suburbs': [
          const VillageRecord(
            villageName: 'Ghatkopar East',
            lgdCode: '400020',
            gramPanchayat: 'Ward N',
            policeStationPostOffice: 'Pant Nagar PS / PO 400077',
          ),
          const VillageRecord(
            villageName: 'Mulund West',
            lgdCode: '400021',
            gramPanchayat: 'Ward T',
            policeStationPostOffice: 'Mulund PS / PO 400080',
          ),
        ],
      },
      'Pune': {
        'Pune City': [
          const VillageRecord(
            villageName: 'Kothrud',
            lgdCode: '411001',
            gramPanchayat: 'Ward 12',
            policeStationPostOffice: 'Kothrud PS / PO 411038',
          ),
          const VillageRecord(
            villageName: 'Hadapsar',
            lgdCode: '411002',
            gramPanchayat: 'Hadapsar Ward',
            policeStationPostOffice: 'Hadapsar PS / PO 411028',
          ),
          const VillageRecord(
            villageName: 'Hinjawadi',
            lgdCode: '411003',
            gramPanchayat: 'Hinjawadi GP',
            policeStationPostOffice: 'Hinjawadi PS / PO 411057',
          ),
        ],
        'Haveli': [
          const VillageRecord(
            villageName: 'Wagholi',
            lgdCode: '411010',
            gramPanchayat: 'Wagholi GP',
            policeStationPostOffice: 'Lonikand PS / PO 412207',
          ),
          const VillageRecord(
            villageName: 'Loni Kalbhor',
            lgdCode: '411011',
            gramPanchayat: 'Loni Kalbhor GP',
            policeStationPostOffice: 'Loni Kalbhor PS / PO 412201',
          ),
        ],
        'Baramati': [
          const VillageRecord(
            villageName: 'Malegaon Bk',
            lgdCode: '411020',
            gramPanchayat: 'Malegaon GP',
            policeStationPostOffice: 'Baramati Rural PS / PO 413115',
          ),
        ],
      },
      'Nagpur': {
        'Nagpur City': [
          const VillageRecord(
            villageName: 'Dharampeth',
            lgdCode: '440001',
            gramPanchayat: 'Ward 15',
            policeStationPostOffice: 'Ambazari PS / PO 440010',
          ),
          const VillageRecord(
            villageName: 'Sitabuldi',
            lgdCode: '440002',
            gramPanchayat: 'Ward 22',
            policeStationPostOffice: 'Sitabuldi PS / PO 440012',
          ),
        ],
        'Kamptee': [
          const VillageRecord(
            villageName: 'Kamptee Cantt',
            lgdCode: '440010',
            gramPanchayat: 'Kamptee GP',
            policeStationPostOffice: 'Kamptee PS / PO 441001',
          ),
        ],
      },
      'Thane': {
        'Thane City': [
          const VillageRecord(
            villageName: 'Ghubunder',
            lgdCode: '400601',
            gramPanchayat: 'Ghodbunder GP',
            policeStationPostOffice: 'Kasarvadavali PS / PO 400615',
          ),
          const VillageRecord(
            villageName: 'Kalyan Rural',
            lgdCode: '400602',
            gramPanchayat: 'Kalyan GP',
            policeStationPostOffice: 'Kalyan PS / PO 421301',
          ),
        ],
      },
    },
    'Manipur': {
      'Churachandpur': {
        'Lamka': [
          const VillageRecord(
            villageName: 'Tuibong',
            lgdCode: '269841',
            gramPanchayat: 'Tuibong GP',
            policeStationPostOffice: 'Churachandpur PS / PO 795128',
          ),
          const VillageRecord(
            villageName: 'Hmarveng',
            lgdCode: '269842',
            gramPanchayat: 'Lamka South GP',
            policeStationPostOffice: 'Churachandpur PS / PO 795128',
          ),
          const VillageRecord(
            villageName: 'New Lamka',
            lgdCode: '269843',
            gramPanchayat: 'New Lamka GP',
            policeStationPostOffice: 'Churachandpur PS / PO 795128',
          ),
          const VillageRecord(
            villageName: 'Rengkai',
            lgdCode: '269844',
            gramPanchayat: 'Rengkai GP',
            policeStationPostOffice: 'Churachandpur PS / PO 795128',
          ),
        ],
        'Saikot': [
          const VillageRecord(
            villageName: 'Saikot Village',
            lgdCode: '269850',
            gramPanchayat: 'Saikot GP',
            policeStationPostOffice: 'Saikot PS / PO 795128',
          ),
          const VillageRecord(
            villageName: 'Mualnuam',
            lgdCode: '269851',
            gramPanchayat: 'Saikot North GP',
            policeStationPostOffice: 'Saikot PS / PO 795128',
          ),
        ],
        'Singngat': [
          const VillageRecord(
            villageName: 'Singngat HQ',
            lgdCode: '269860',
            gramPanchayat: 'Singngat GP',
            policeStationPostOffice: 'Singngat PS / PO 795140',
          ),
          const VillageRecord(
            villageName: 'Behiang',
            lgdCode: '269861',
            gramPanchayat: 'Behiang Border GP',
            policeStationPostOffice: 'Singngat PS / PO 795140',
          ),
        ],
      },
      'Bishnupur': {
        'Moirang': [
          const VillageRecord(
            villageName: 'Kwakta',
            lgdCode: '269910',
            gramPanchayat: 'Kwakta Nagar Panchayat',
            policeStationPostOffice: 'Moirang PS / PO 795133',
          ),
          const VillageRecord(
            villageName: 'Moirang Lamkhai',
            lgdCode: '269911',
            gramPanchayat: 'Moirang Part-II GP',
            policeStationPostOffice: 'Moirang PS / PO 795133',
          ),
          const VillageRecord(
            villageName: 'Sendra',
            lgdCode: '269912',
            gramPanchayat: 'Sendra Island GP',
            policeStationPostOffice: 'Moirang PS / PO 795133',
          ),
          const VillageRecord(
            villageName: 'Thanga',
            lgdCode: '269913',
            gramPanchayat: 'Thanga Island GP',
            policeStationPostOffice: 'Moirang PS / PO 795133',
          ),
        ],
        'Nambol': [
          const VillageRecord(
            villageName: 'Nambol Makha',
            lgdCode: '269920',
            gramPanchayat: 'Nambol GP',
            policeStationPostOffice: 'Nambol PS / PO 795134',
          ),
          const VillageRecord(
            villageName: 'Leimapokpam',
            lgdCode: '269921',
            gramPanchayat: 'Leimapokpam GP',
            policeStationPostOffice: 'Nambol PS / PO 795134',
          ),
        ],
      },
      'Imphal West': {
        'Lamphelpat': [
          const VillageRecord(
            villageName: 'Lamphel Sanakeithel',
            lgdCode: '269701',
            gramPanchayat: 'Lamphelpat Ward 1',
            policeStationPostOffice: 'Lamphel PS / PO 795004',
          ),
        ],
        'Patsoi': [
          const VillageRecord(
            villageName: 'Patsoi Part I',
            lgdCode: '269710',
            gramPanchayat: 'Patsoi GP',
            policeStationPostOffice: 'Patsoi PS / PO 795004',
          ),
          const VillageRecord(
            villageName: 'Takyel',
            lgdCode: '269711',
            gramPanchayat: 'Takyel GP',
            policeStationPostOffice: 'Patsoi PS / PO 795004',
          ),
        ],
      },
      'Imphal East': {
        'Porompat': [
          const VillageRecord(
            villageName: 'Porompat Ward 1',
            lgdCode: '269720',
            gramPanchayat: 'Porompat GP',
            policeStationPostOffice: 'Porompat PS / PO 795005',
          ),
          const VillageRecord(
            villageName: 'Lamlong',
            lgdCode: '269721',
            gramPanchayat: 'Lamlong GP',
            policeStationPostOffice: 'Porompat PS / PO 795010',
          ),
        ],
      },
    },
    'Meghalaya': {
      'East Khasi Hills': {
        'Shillong': [
          const VillageRecord(
            villageName: 'Laitumkhrah',
            lgdCode: '271001',
            gramPanchayat: 'Laitumkhrah Dorbar',
            policeStationPostOffice: 'Laitumkhrah PS / PO 793003',
          ),
          const VillageRecord(
            villageName: 'Mawlai',
            lgdCode: '271002',
            gramPanchayat: 'Mawlai Dorbar',
            policeStationPostOffice: 'Mawlai PS / PO 793008',
          ),
          const VillageRecord(
            villageName: 'Polo',
            lgdCode: '271003',
            gramPanchayat: 'Polo Ward',
            policeStationPostOffice: 'Sadar PS / PO 793001',
          ),
        ],
        'Sohra': [
          const VillageRecord(
            villageName: 'Cherrapunjee Town',
            lgdCode: '271010',
            gramPanchayat: 'Sohra Dorbar',
            policeStationPostOffice: 'Sohra PS / PO 793108',
          ),
          const VillageRecord(
            villageName: 'Mawkdok',
            lgdCode: '271011',
            gramPanchayat: 'Mawkdok Dorbar',
            policeStationPostOffice: 'Sohra PS / PO 793108',
          ),
        ],
      },
      'West Garo Hills': {
        'Tura': [
          const VillageRecord(
            villageName: 'Hawakhana',
            lgdCode: '272001',
            gramPanchayat: 'Hawakhana Ward',
            policeStationPostOffice: 'Tura PS / PO 794001',
          ),
          const VillageRecord(
            villageName: 'Rongram',
            lgdCode: '272002',
            gramPanchayat: 'Rongram GP',
            policeStationPostOffice: 'Rongram PS / PO 794002',
          ),
        ],
      },
    },
    'Mizoram': {
      'Aizawl': {
        'Aizawl Urban': [
          const VillageRecord(
            villageName: 'Khatla',
            lgdCode: '281001',
            gramPanchayat: 'Khatla Local Council',
            policeStationPostOffice: 'Khatla PS / PO 796001',
          ),
          const VillageRecord(
            villageName: 'Bawngkawn',
            lgdCode: '281002',
            gramPanchayat: 'Bawngkawn LC',
            policeStationPostOffice: 'Bawngkawn PS / PO 796014',
          ),
          const VillageRecord(
            villageName: 'Kulambawn',
            lgdCode: '281003',
            gramPanchayat: 'Kulambawn LC',
            policeStationPostOffice: 'Aizawl PS / PO 796005',
          ),
        ],
        'Darlawn': [
          const VillageRecord(
            villageName: 'Darlawn Village',
            lgdCode: '281010',
            gramPanchayat: 'Darlawn VC',
            policeStationPostOffice: 'Darlawn PS / PO 796111',
          ),
        ],
      },
      'Lunglei': {
        'Lunglei Town': [
          const VillageRecord(
            villageName: 'Bazar Veng',
            lgdCode: '282001',
            gramPanchayat: 'Bazar Veng VC',
            policeStationPostOffice: 'Lunglei PS / PO 796701',
          ),
          const VillageRecord(
            villageName: 'Rahsi Veng',
            lgdCode: '282002',
            gramPanchayat: 'Rahsi Veng VC',
            policeStationPostOffice: 'Lunglei PS / PO 796701',
          ),
        ],
      },
    },
    'Nagaland': {
      'Kohima': {
        'Kohima Urban': [
          const VillageRecord(
            villageName: 'High School Colony',
            lgdCode: '261001',
            gramPanchayat: 'Ward 1',
            policeStationPostOffice: 'North PS / PO 797001',
          ),
          const VillageRecord(
            villageName: 'Midland Colony',
            lgdCode: '261002',
            gramPanchayat: 'Ward 9',
            policeStationPostOffice: 'South PS / PO 797001',
          ),
        ],
        'Jakhama': [
          const VillageRecord(
            villageName: 'Jakhama Village',
            lgdCode: '261010',
            gramPanchayat: 'Jakhama VC',
            policeStationPostOffice: 'Zubza PS / PO 797005',
          ),
          const VillageRecord(
            villageName: 'Viswema',
            lgdCode: '261011',
            gramPanchayat: 'Viswema VC',
            policeStationPostOffice: 'Viswema PS / PO 797005',
          ),
        ],
      },
      'Dimapur': {
        'Dimapur Town': [
          const VillageRecord(
            villageName: 'Purana Bazar',
            lgdCode: '262001',
            gramPanchayat: 'Purana Bazar GP',
            policeStationPostOffice: 'East PS / PO 797112',
          ),
          const VillageRecord(
            villageName: 'Chumoukedima',
            lgdCode: '262002',
            gramPanchayat: 'Chumoukedima TC',
            policeStationPostOffice: 'Chumoukedima PS / PO 797103',
          ),
        ],
      },
    },
    'Odisha': {
      'Khordha': {
        'Bhubaneswar': [
          const VillageRecord(
            villageName: 'Patia',
            lgdCode: '251001',
            gramPanchayat: 'Patia Ward',
            policeStationPostOffice: 'Infocity PS / PO 751024',
          ),
          const VillageRecord(
            villageName: 'Chandrasekharpur',
            lgdCode: '251002',
            gramPanchayat: 'CSPur Ward',
            policeStationPostOffice: 'Chandrasekharpur PS / PO 751016',
          ),
          const VillageRecord(
            villageName: 'Jatni',
            lgdCode: '251003',
            gramPanchayat: 'Jatni GP',
            policeStationPostOffice: 'Jatni PS / PO 752050',
          ),
        ],
        'Khordha Sadar': [
          const VillageRecord(
            villageName: 'Begunia',
            lgdCode: '251010',
            gramPanchayat: 'Begunia GP',
            policeStationPostOffice: 'Begunia PS / PO 752062',
          ),
        ],
      },
      'Cuttack': {
        'Cuttack City': [
          const VillageRecord(
            villageName: 'Choudwar',
            lgdCode: '252001',
            gramPanchayat: 'Choudwar GP',
            policeStationPostOffice: 'Choudwar PS / PO 754025',
          ),
          const VillageRecord(
            villageName: 'Bidanasi',
            lgdCode: '252002',
            gramPanchayat: 'Bidanasi Ward',
            policeStationPostOffice: 'Bidanasi PS / PO 753014',
          ),
        ],
      },
      'Puri': {
        'Puri Sadar': [
          const VillageRecord(
            villageName: 'Konark',
            lgdCode: '253001',
            gramPanchayat: 'Konark NAC',
            policeStationPostOffice: 'Konark PS / PO 752111',
          ),
          const VillageRecord(
            villageName: 'Pipili',
            lgdCode: '253002',
            gramPanchayat: 'Pipili GP',
            policeStationPostOffice: 'Pipili PS / PO 752104',
          ),
        ],
      },
    },
    'Punjab': {
      'Ludhiana': {
        'Ludhiana East': [
          const VillageRecord(
            villageName: 'Sahnewal',
            lgdCode: '141001',
            gramPanchayat: 'Sahnewal GP',
            policeStationPostOffice: 'Sahnewal PS / PO 141120',
          ),
          const VillageRecord(
            villageName: 'Samrala',
            lgdCode: '141002',
            gramPanchayat: 'Samrala GP',
            policeStationPostOffice: 'Samrala PS / PO 141114',
          ),
        ],
        'Ludhiana West': [
          const VillageRecord(
            villageName: 'Jagraon',
            lgdCode: '141010',
            gramPanchayat: 'Jagraon GP',
            policeStationPostOffice: 'Jagraon PS / PO 142026',
          ),
          const VillageRecord(
            villageName: 'Mullanpur Dakha',
            lgdCode: '141011',
            gramPanchayat: 'Dakha GP',
            policeStationPostOffice: 'Dakha PS / PO 141101',
          ),
        ],
      },
      'Amritsar': {
        'Amritsar Urban': [
          const VillageRecord(
            villageName: 'Chheharta',
            lgdCode: '142001',
            gramPanchayat: 'Chheharta Ward',
            policeStationPostOffice: 'Chheharta PS / PO 143105',
          ),
          const VillageRecord(
            villageName: 'Majitha',
            lgdCode: '142002',
            gramPanchayat: 'Majitha GP',
            policeStationPostOffice: 'Majitha PS / PO 143601',
          ),
        ],
      },
      'Jalandhar': {
        'Jalandhar City': [
          const VillageRecord(
            villageName: 'Adampur',
            lgdCode: '143001',
            gramPanchayat: 'Adampur GP',
            policeStationPostOffice: 'Adampur PS / PO 144102',
          ),
          const VillageRecord(
            villageName: 'Nakodar',
            lgdCode: '143002',
            gramPanchayat: 'Nakodar GP',
            policeStationPostOffice: 'Nakodar PS / PO 144040',
          ),
        ],
      },
      'SAS Nagar': {
        'Mohali': [
          const VillageRecord(
            villageName: 'Kharar',
            lgdCode: '144001',
            gramPanchayat: 'Kharar GP',
            policeStationPostOffice: 'Kharar PS / PO 140301',
          ),
          const VillageRecord(
            villageName: 'Zirakpur',
            lgdCode: '144002',
            gramPanchayat: 'Zirakpur MC',
            policeStationPostOffice: 'Zirakpur PS / PO 140603',
          ),
          const VillageRecord(
            villageName: 'Dera Bassi',
            lgdCode: '144003',
            gramPanchayat: 'Dera Bassi GP',
            policeStationPostOffice: 'Dera Bassi PS / PO 140507',
          ),
        ],
      },
    },
    'Rajasthan': {
      'Jaipur': {
        'Jaipur City': [
          const VillageRecord(
            villageName: 'Sanganer',
            lgdCode: '301101',
            gramPanchayat: 'Sanganer Ward',
            policeStationPostOffice: 'Sanganer PS / PO 302029',
          ),
          const VillageRecord(
            villageName: 'Amer',
            lgdCode: '301102',
            gramPanchayat: 'Amer Ward',
            policeStationPostOffice: 'Amer PS / PO 302028',
          ),
          const VillageRecord(
            villageName: 'Jagatpura',
            lgdCode: '301103',
            gramPanchayat: 'Jagatpura GP',
            policeStationPostOffice: 'Ramnagariya PS / PO 302017',
          ),
        ],
        'Chomu': [
          const VillageRecord(
            villageName: 'Chomu Rural',
            lgdCode: '301110',
            gramPanchayat: 'Chomu GP',
            policeStationPostOffice: 'Chomu PS / PO 303702',
          ),
        ],
      },
      'Jodhpur': {
        'Jodhpur City': [
          const VillageRecord(
            villageName: 'Mandore',
            lgdCode: '301201',
            gramPanchayat: 'Mandore GP',
            policeStationPostOffice: 'Mandore PS / PO 342007',
          ),
          const VillageRecord(
            villageName: 'Luni',
            lgdCode: '301202',
            gramPanchayat: 'Luni GP',
            policeStationPostOffice: 'Luni PS / PO 342802',
          ),
        ],
      },
      'Udaipur': {
        'Udaipur City': [
          const VillageRecord(
            villageName: 'Badgaon',
            lgdCode: '301301',
            gramPanchayat: 'Badgaon GP',
            policeStationPostOffice: 'Sukher PS / PO 313011',
          ),
          const VillageRecord(
            villageName: 'Girwa',
            lgdCode: '301302',
            gramPanchayat: 'Girwa GP',
            policeStationPostOffice: 'Hiran Magri PS / PO 313002',
          ),
        ],
      },
      'Kota': {
        'Kota City': [
          const VillageRecord(
            villageName: 'Ladpura',
            lgdCode: '301401',
            gramPanchayat: 'Ladpura GP',
            policeStationPostOffice: 'Nayapura PS / PO 324001',
          ),
          const VillageRecord(
            villageName: 'Sangod',
            lgdCode: '301402',
            gramPanchayat: 'Sangod GP',
            policeStationPostOffice: 'Sangod PS / PO 325601',
          ),
        ],
      },
    },
    'Sikkim': {
      'Gangtok': {
        'Gangtok Urban': [
          const VillageRecord(
            villageName: 'Deorali',
            lgdCode: '737001',
            gramPanchayat: 'Deorali Ward',
            policeStationPostOffice: 'Sadar PS / PO 737102',
          ),
          const VillageRecord(
            villageName: 'Tadong',
            lgdCode: '737002',
            gramPanchayat: 'Tadong Ward',
            policeStationPostOffice: 'Tadong PS / PO 737102',
          ),
          const VillageRecord(
            villageName: 'Ranipool',
            lgdCode: '737003',
            gramPanchayat: 'Ranipool GP',
            policeStationPostOffice: 'Ranipool PS / PO 737135',
          ),
        ],
        'Singtam': [
          const VillageRecord(
            villageName: 'Singtam Bazar',
            lgdCode: '737010',
            gramPanchayat: 'Singtam NAC',
            policeStationPostOffice: 'Singtam PS / PO 737134',
          ),
        ],
      },
      'Namchi': {
        'Namchi Town': [
          const VillageRecord(
            villageName: 'Jorethang',
            lgdCode: '737101',
            gramPanchayat: 'Jorethang NAC',
            policeStationPostOffice: 'Jorethang PS / PO 737121',
          ),
          const VillageRecord(
            villageName: 'Ravangla',
            lgdCode: '737102',
            gramPanchayat: 'Ravangla GP',
            policeStationPostOffice: 'Ravangla PS / PO 737139',
          ),
        ],
      },
    },
    'Tamil Nadu': {
      'Chennai': {
        'Chennai Central': [
          const VillageRecord(
            villageName: 'Mylapore',
            lgdCode: '600001',
            gramPanchayat: 'Ward 120',
            policeStationPostOffice: 'Mylapore PS / PO 600004',
          ),
          const VillageRecord(
            villageName: 'T Nagar',
            lgdCode: '600002',
            gramPanchayat: 'Ward 134',
            policeStationPostOffice: 'T Nagar PS / PO 600017',
          ),
          const VillageRecord(
            villageName: 'Guindy',
            lgdCode: '600003',
            gramPanchayat: 'Ward 160',
            policeStationPostOffice: 'Guindy PS / PO 600032',
          ),
        ],
        'Chennai South': [
          const VillageRecord(
            villageName: 'Adyar',
            lgdCode: '600010',
            gramPanchayat: 'Ward 175',
            policeStationPostOffice: 'Adyar PS / PO 600020',
          ),
          const VillageRecord(
            villageName: 'Velachery',
            lgdCode: '600011',
            gramPanchayat: 'Ward 177',
            policeStationPostOffice: 'Velachery PS / PO 600042',
          ),
          const VillageRecord(
            villageName: 'Sholinganallur',
            lgdCode: '600012',
            gramPanchayat: 'Ward 198',
            policeStationPostOffice: 'Semmancheri PS / PO 600119',
          ),
        ],
      },
      'Coimbatore': {
        'Coimbatore City': [
          const VillageRecord(
            villageName: 'Gandhipuram',
            lgdCode: '641001',
            gramPanchayat: 'Ward 30',
            policeStationPostOffice: 'Katoor PS / PO 641012',
          ),
          const VillageRecord(
            villageName: 'Peelamedu',
            lgdCode: '641002',
            gramPanchayat: 'Ward 45',
            policeStationPostOffice: 'Peelamedu PS / PO 641004',
          ),
          const VillageRecord(
            villageName: 'Saravanampatti',
            lgdCode: '641003',
            gramPanchayat: 'Ward 22',
            policeStationPostOffice: 'Saravanampatti PS / PO 641035',
          ),
        ],
        'Pollachi': [
          const VillageRecord(
            villageName: 'Pollachi Rural',
            lgdCode: '641010',
            gramPanchayat: 'Pollachi GP',
            policeStationPostOffice: 'Pollachi PS / PO 642001',
          ),
        ],
      },
      'Madurai': {
        'Madurai City': [
          const VillageRecord(
            villageName: 'Tallakulam',
            lgdCode: '625001',
            gramPanchayat: 'Ward 40',
            policeStationPostOffice: 'Tallakulam PS / PO 625002',
          ),
          const VillageRecord(
            villageName: 'Thirunagar',
            lgdCode: '625002',
            gramPanchayat: 'Thirunagar GP',
            policeStationPostOffice: 'Thirunagar PS / PO 625006',
          ),
        ],
      },
    },
    'Telangana': {
      'Hyderabad': {
        'Hyderabad Central': [
          const VillageRecord(
            villageName: 'Khairatabad',
            lgdCode: '500001',
            gramPanchayat: 'Circle 17 Ward 91',
            policeStationPostOffice: 'Khairatabad PS / PO 500004',
          ),
          const VillageRecord(
            villageName: 'Banjara Hills',
            lgdCode: '500002',
            gramPanchayat: 'Circle 18 Ward 93',
            policeStationPostOffice: 'Banjara Hills PS / PO 500034',
          ),
          const VillageRecord(
            villageName: 'Jubilee Hills',
            lgdCode: '500003',
            gramPanchayat: 'Circle 18 Ward 94',
            policeStationPostOffice: 'Jubilee Hills PS / PO 500033',
          ),
        ],
        'Secunderabad': [
          const VillageRecord(
            villageName: 'Marredpally',
            lgdCode: '500010',
            gramPanchayat: 'Secunderabad Ward 1',
            policeStationPostOffice: 'Marredpally PS / PO 500026',
          ),
          const VillageRecord(
            villageName: 'Tirumalagiri',
            lgdCode: '500011',
            gramPanchayat: 'Tirumalagiri Cantt',
            policeStationPostOffice: 'Tirumalagiri PS / PO 500015',
          ),
        ],
      },
      'Medchal-Malkajgiri': {
        'Malkajgiri': [
          const VillageRecord(
            villageName: 'Alwal',
            lgdCode: '500020',
            gramPanchayat: 'Alwal Ward 133',
            policeStationPostOffice: 'Alwal PS / PO 500010',
          ),
          const VillageRecord(
            villageName: 'Kukatpally',
            lgdCode: '500021',
            gramPanchayat: 'Kukatpally Ward 120',
            policeStationPostOffice: 'Kukatpally PS / PO 500072',
          ),
        ],
        'Medchal': [
          const VillageRecord(
            villageName: 'Medchal Town',
            lgdCode: '500030',
            gramPanchayat: 'Medchal GP',
            policeStationPostOffice: 'Medchal PS / PO 501401',
          ),
        ],
      },
      'Rangareddy': {
        'Serilingampally': [
          const VillageRecord(
            villageName: 'Gachibowli',
            lgdCode: '500040',
            gramPanchayat: 'Gachibowli Ward 105',
            policeStationPostOffice: 'Gachibowli PS / PO 500032',
          ),
          const VillageRecord(
            villageName: 'Madhapur',
            lgdCode: '500041',
            gramPanchayat: 'Madhapur Ward 107',
            policeStationPostOffice: 'Madhapur PS / PO 500081',
          ),
        ],
        'Rajendranagar': [
          const VillageRecord(
            villageName: 'Attapur',
            lgdCode: '500050',
            gramPanchayat: 'Attapur Ward 61',
            policeStationPostOffice: 'Rajendranagar PS / PO 500048',
          ),
        ],
      },
      'Warangal': {
        'Warangal Urban': [
          const VillageRecord(
            villageName: 'Hanamkonda',
            lgdCode: '506001',
            gramPanchayat: 'Hanamkonda Ward',
            policeStationPostOffice: 'Hanamkonda PS / PO 506001',
          ),
          const VillageRecord(
            villageName: 'Kazipet',
            lgdCode: '506002',
            gramPanchayat: 'Kazipet Ward',
            policeStationPostOffice: 'Kazipet PS / PO 506003',
          ),
        ],
      },
    },
    'Tripura': {
      'West Tripura': {
        'Agartala': [
          const VillageRecord(
            villageName: 'Banamalipur',
            lgdCode: '799001',
            gramPanchayat: 'Ward 12',
            policeStationPostOffice: 'East Agartala PS / PO 799001',
          ),
          const VillageRecord(
            villageName: 'Kunjaban',
            lgdCode: '799002',
            gramPanchayat: 'Ward 4',
            policeStationPostOffice: 'New Capital Complex PS / PO 799006',
          ),
          const VillageRecord(
            villageName: 'Badharghat',
            lgdCode: '799003',
            gramPanchayat: 'Badharghat GP',
            policeStationPostOffice: 'Amtali PS / PO 799003',
          ),
        ],
        'Jirania': [
          const VillageRecord(
            villageName: 'Jirania Rural',
            lgdCode: '799010',
            gramPanchayat: 'Jirania GP',
            policeStationPostOffice: 'Jirania PS / PO 799035',
          ),
          const VillageRecord(
            villageName: 'Ranirbazar',
            lgdCode: '799011',
            gramPanchayat: 'Ranirbazar NAC',
            policeStationPostOffice: 'Ranirbazar PS / PO 799035',
          ),
        ],
      },
      'Gomati': {
        'Udaipur': [
          const VillageRecord(
            villageName: 'Matabari',
            lgdCode: '799101',
            gramPanchayat: 'Matabari GP',
            policeStationPostOffice: 'Radhakishorepur PS / PO 799114',
          ),
          const VillageRecord(
            villageName: 'Kakraban',
            lgdCode: '799102',
            gramPanchayat: 'Kakraban GP',
            policeStationPostOffice: 'Kakraban PS / PO 799105',
          ),
        ],
      },
    },
    'Uttar Pradesh': {
      'Lucknow': {
        'Lucknow Urban': [
          const VillageRecord(
            villageName: 'Gomti Nagar',
            lgdCode: '226001',
            gramPanchayat: 'Gomti Nagar Ward',
            policeStationPostOffice: 'Gomti Nagar PS / PO 226010',
          ),
          const VillageRecord(
            villageName: 'Aliganj',
            lgdCode: '226002',
            gramPanchayat: 'Aliganj Ward',
            policeStationPostOffice: 'Aliganj PS / PO 226024',
          ),
          const VillageRecord(
            villageName: 'Chinhat',
            lgdCode: '226003',
            gramPanchayat: 'Chinhat GP',
            policeStationPostOffice: 'Chinhat PS / PO 226028',
          ),
        ],
        'Bakshi Ka Talab': [
          const VillageRecord(
            villageName: 'BKT Rural',
            lgdCode: '226010',
            gramPanchayat: 'BKT GP',
            policeStationPostOffice: 'BKT PS / PO 226201',
          ),
        ],
        'Mohanlalganj': [
          const VillageRecord(
            villageName: 'Mohanlalganj Rural',
            lgdCode: '226020',
            gramPanchayat: 'Mohanlalganj GP',
            policeStationPostOffice: 'Mohanlalganj PS / PO 226301',
          ),
        ],
      },
      'Kanpur Nagar': {
        'Kanpur City': [
          const VillageRecord(
            villageName: 'Kalyanpur',
            lgdCode: '208001',
            gramPanchayat: 'Kalyanpur Ward',
            policeStationPostOffice: 'Kalyanpur PS / PO 208017',
          ),
          const VillageRecord(
            villageName: 'Govind Nagar',
            lgdCode: '208002',
            gramPanchayat: 'Govind Nagar Ward',
            policeStationPostOffice: 'Govind Nagar PS / PO 208006',
          ),
        ],
        'Bilhaur': [
          const VillageRecord(
            villageName: 'Bilhaur Rural',
            lgdCode: '208010',
            gramPanchayat: 'Bilhaur GP',
            policeStationPostOffice: 'Bilhaur PS / PO 209202',
          ),
        ],
      },
      'Varanasi': {
        'Varanasi City': [
          const VillageRecord(
            villageName: 'Lanka',
            lgdCode: '221001',
            gramPanchayat: 'Lanka Ward',
            policeStationPostOffice: 'Lanka PS / PO 221005',
          ),
          const VillageRecord(
            villageName: 'Shivpur',
            lgdCode: '221002',
            gramPanchayat: 'Shivpur Ward',
            policeStationPostOffice: 'Shivpur PS / PO 221003',
          ),
          const VillageRecord(
            villageName: 'Sarnath',
            lgdCode: '221003',
            gramPanchayat: 'Sarnath GP',
            policeStationPostOffice: 'Sarnath PS / PO 221007',
          ),
        ],
        'Pindra': [
          const VillageRecord(
            villageName: 'Pindra Rural',
            lgdCode: '221010',
            gramPanchayat: 'Pindra GP',
            policeStationPostOffice: 'Phulpur PS / PO 221206',
          ),
        ],
      },
      'Gautam Buddha Nagar': {
        'Noida': [
          const VillageRecord(
            villageName: 'Noida Sector 62',
            lgdCode: '201301',
            gramPanchayat: 'Sector 62 Ward',
            policeStationPostOffice: 'Sector 58 PS / PO 201309',
          ),
          const VillageRecord(
            villageName: 'Bhangel',
            lgdCode: '201302',
            gramPanchayat: 'Bhangel GP',
            policeStationPostOffice: 'Sector 49 PS / PO 201304',
          ),
        ],
        'Greater Noida': [
          const VillageRecord(
            villageName: 'Surajpur',
            lgdCode: '201310',
            gramPanchayat: 'Surajpur GP',
            policeStationPostOffice: 'Surajpur PS / PO 201306',
          ),
          const VillageRecord(
            villageName: 'Dadri',
            lgdCode: '201311',
            gramPanchayat: 'Dadri GP',
            policeStationPostOffice: 'Dadri PS / PO 203207',
          ),
        ],
      },
      'Agra': {
        'Agra City': [
          const VillageRecord(
            villageName: 'Tajganj',
            lgdCode: '282001',
            gramPanchayat: 'Tajganj Ward',
            policeStationPostOffice: 'Tajganj PS / PO 282001',
          ),
          const VillageRecord(
            villageName: 'Dayalbagh',
            lgdCode: '282002',
            gramPanchayat: 'Dayalbagh GP',
            policeStationPostOffice: 'New Agra PS / PO 282005',
          ),
        ],
      },
    },
    'Uttarakhand': {
      'Dehradun': {
        'Dehradun City': [
          const VillageRecord(
            villageName: 'Rajpur Road',
            lgdCode: '248001',
            gramPanchayat: 'Rajpur Ward',
            policeStationPostOffice: 'Rajpur PS / PO 248009',
          ),
          const VillageRecord(
            villageName: 'Clement Town',
            lgdCode: '248002',
            gramPanchayat: 'Clement Town Cantt',
            policeStationPostOffice: 'Clement Town PS / PO 248002',
          ),
          const VillageRecord(
            villageName: 'Prem Nagar',
            lgdCode: '248003',
            gramPanchayat: 'Prem Nagar GP',
            policeStationPostOffice: 'Prem Nagar PS / PO 248007',
          ),
        ],
        'Rishikesh': [
          const VillageRecord(
            villageName: 'Tapovan',
            lgdCode: '248010',
            gramPanchayat: 'Tapovan GP',
            policeStationPostOffice: 'Muni Ki Reti PS / PO 249192',
          ),
          const VillageRecord(
            villageName: 'Raiwala',
            lgdCode: '248011',
            gramPanchayat: 'Raiwala GP',
            policeStationPostOffice: 'Raiwala PS / PO 249205',
          ),
        ],
      },
      'Haridwar': {
        'Haridwar City': [
          const VillageRecord(
            villageName: 'Jwalapur',
            lgdCode: '249401',
            gramPanchayat: 'Jwalapur Ward',
            policeStationPostOffice: 'Jwalapur PS / PO 249407',
          ),
          const VillageRecord(
            villageName: 'Kankhal',
            lgdCode: '249402',
            gramPanchayat: 'Kankhal Ward',
            policeStationPostOffice: 'Kankhal PS / PO 249408',
          ),
        ],
        'Roorkee': [
          const VillageRecord(
            villageName: 'Roorkee Cantt',
            lgdCode: '249410',
            gramPanchayat: 'Roorkee Ward',
            policeStationPostOffice: 'Roorkee PS / PO 247667',
          ),
          const VillageRecord(
            villageName: 'Manglaur',
            lgdCode: '249411',
            gramPanchayat: 'Manglaur GP',
            policeStationPostOffice: 'Manglaur PS / PO 247656',
          ),
        ],
      },
      'Nainital': {
        'Haldwani': [
          const VillageRecord(
            villageName: 'Kathgodam',
            lgdCode: '263101',
            gramPanchayat: 'Kathgodam Ward',
            policeStationPostOffice: 'Kathgodam PS / PO 263126',
          ),
          const VillageRecord(
            villageName: 'Mukhani',
            lgdCode: '263102',
            gramPanchayat: 'Mukhani GP',
            policeStationPostOffice: 'Haldwani PS / PO 263139',
          ),
        ],
        'Nainital Town': [
          const VillageRecord(
            villageName: 'Mallital',
            lgdCode: '263110',
            gramPanchayat: 'Mallital Ward',
            policeStationPostOffice: 'Mallital PS / PO 263001',
          ),
          const VillageRecord(
            villageName: 'Bhimtal',
            lgdCode: '263111',
            gramPanchayat: 'Bhimtal GP',
            policeStationPostOffice: 'Bhimtal PS / PO 263136',
          ),
        ],
      },
    },
    'West Bengal': {
      'Kolkata': {
        'Kolkata Central': [
          const VillageRecord(
            villageName: 'Bowbazar',
            lgdCode: '700001',
            gramPanchayat: 'Ward 47',
            policeStationPostOffice: 'Bowbazar PS / PO 700012',
          ),
          const VillageRecord(
            villageName: 'Park Street',
            lgdCode: '700002',
            gramPanchayat: 'Ward 63',
            policeStationPostOffice: 'Park Street PS / PO 700016',
          ),
        ],
        'Kolkata South': [
          const VillageRecord(
            villageName: 'Alipore',
            lgdCode: '700010',
            gramPanchayat: 'Ward 74',
            policeStationPostOffice: 'Alipore PS / PO 700027',
          ),
          const VillageRecord(
            villageName: 'Ballygunge',
            lgdCode: '700011',
            gramPanchayat: 'Ward 69',
            policeStationPostOffice: 'Ballygunge PS / PO 700019',
          ),
          const VillageRecord(
            villageName: 'Jadavpur',
            lgdCode: '700012',
            gramPanchayat: 'Ward 96',
            policeStationPostOffice: 'Jadavpur PS / PO 700032',
          ),
        ],
      },
      'North 24 Parganas': {
        'Bidhannagar': [
          const VillageRecord(
            villageName: 'Salt Lake Sector 1',
            lgdCode: '700101',
            gramPanchayat: 'Ward 29',
            policeStationPostOffice: 'Bidhannagar North PS / PO 700064',
          ),
          const VillageRecord(
            villageName: 'Salt Lake Sector 5',
            lgdCode: '700102',
            gramPanchayat: 'Ward 38',
            policeStationPostOffice: 'Electronics Complex PS / PO 700091',
          ),
          const VillageRecord(
            villageName: 'New Town',
            lgdCode: '700103',
            gramPanchayat: 'New Town Action Area 1',
            policeStationPostOffice: 'New Town PS / PO 700156',
          ),
        ],
        'Barasat': [
          const VillageRecord(
            villageName: 'Barasat Town',
            lgdCode: '700110',
            gramPanchayat: 'Barasat Ward 10',
            policeStationPostOffice: 'Barasat PS / PO 700124',
          ),
          const VillageRecord(
            villageName: 'Madhyamgram',
            lgdCode: '700111',
            gramPanchayat: 'Madhyamgram GP',
            policeStationPostOffice: 'Madhyamgram PS / PO 700129',
          ),
        ],
      },
      'Darjeeling': {
        'Darjeeling Sadar': [
          const VillageRecord(
            villageName: 'Ghoom',
            lgdCode: '734101',
            gramPanchayat: 'Ghoom Jorebunglow GP',
            policeStationPostOffice: 'Jorebunglow PS / PO 734102',
          ),
          const VillageRecord(
            villageName: 'Batasia',
            lgdCode: '734102',
            gramPanchayat: 'Batasia GP',
            policeStationPostOffice: 'Darjeeling PS / PO 734101',
          ),
        ],
        'Siliguri': [
          const VillageRecord(
            villageName: 'Matigara',
            lgdCode: '734001',
            gramPanchayat: 'Matigara GP',
            policeStationPostOffice: 'Matigara PS / PO 734010',
          ),
          const VillageRecord(
            villageName: 'Pradhan Nagar',
            lgdCode: '734002',
            gramPanchayat: 'Pradhan Nagar Ward',
            policeStationPostOffice: 'Pradhan Nagar PS / PO 734003',
          ),
        ],
      },
      'Howrah': {
        'Howrah City': [
          const VillageRecord(
            villageName: 'Shibpur',
            lgdCode: '711101',
            gramPanchayat: 'Ward 32',
            policeStationPostOffice: 'Shibpur PS / PO 711102',
          ),
          const VillageRecord(
            villageName: 'Uluberia',
            lgdCode: '711102',
            gramPanchayat: 'Uluberia GP',
            policeStationPostOffice: 'Uluberia PS / PO 711315',
          ),
        ],
      },
    },
    'Andaman and Nicobar Islands': {
      'South Andaman': {
        'Port Blair': [
          const VillageRecord(
            villageName: 'Aberdeen Bazar',
            lgdCode: '744101',
            gramPanchayat: 'Port Blair Ward 2',
            policeStationPostOffice: 'Aberdeen PS / PO 744101',
          ),
          const VillageRecord(
            villageName: 'Garacharma',
            lgdCode: '744102',
            gramPanchayat: 'Garacharma GP',
            policeStationPostOffice: 'Pahargaon PS / PO 744105',
          ),
          const VillageRecord(
            villageName: 'Dollygunj',
            lgdCode: '744103',
            gramPanchayat: 'Dollygunj GP',
            policeStationPostOffice: 'Pahargaon PS / PO 744103',
          ),
        ],
        'Ferrargunj': [
          const VillageRecord(
            villageName: 'Ferrargunj Village',
            lgdCode: '744110',
            gramPanchayat: 'Ferrargunj GP',
            policeStationPostOffice: 'Humfrygunj PS / PO 744206',
          ),
        ],
      },
      'North and Middle Andaman': {
        'Mayabunder': [
          const VillageRecord(
            villageName: 'Mayabunder Town',
            lgdCode: '744201',
            gramPanchayat: 'Mayabunder GP',
            policeStationPostOffice: 'Mayabunder PS / PO 744204',
          ),
          const VillageRecord(
            villageName: 'Diglipur',
            lgdCode: '744202',
            gramPanchayat: 'Diglipur GP',
            policeStationPostOffice: 'Diglipur PS / PO 744202',
          ),
        ],
      },
    },
    'Chandigarh': {
      'Chandigarh': {
        'Chandigarh Urban': [
          const VillageRecord(
            villageName: 'Sector 17',
            lgdCode: '160001',
            gramPanchayat: 'Chandigarh Ward 5',
            policeStationPostOffice: 'Sector 17 PS / PO 160017',
          ),
          const VillageRecord(
            villageName: 'Sector 35',
            lgdCode: '160002',
            gramPanchayat: 'Chandigarh Ward 12',
            policeStationPostOffice: 'Sector 36 PS / PO 160035',
          ),
          const VillageRecord(
            villageName: 'Manimajra',
            lgdCode: '160003',
            gramPanchayat: 'Manimajra Ward',
            policeStationPostOffice: 'Manimajra PS / PO 160101',
          ),
          const VillageRecord(
            villageName: 'Burail',
            lgdCode: '160004',
            gramPanchayat: 'Burail GP',
            policeStationPostOffice: 'Sector 34 PS / PO 160047',
          ),
        ],
      },
    },
    'Dadra and Nagar Haveli and Daman and Diu': {
      'Daman': {
        'Daman Town': [
          const VillageRecord(
            villageName: 'Moti Daman',
            lgdCode: '396201',
            gramPanchayat: 'Moti Daman Ward',
            policeStationPostOffice: 'Moti Daman PS / PO 396220',
          ),
          const VillageRecord(
            villageName: 'Nani Daman',
            lgdCode: '396202',
            gramPanchayat: 'Nani Daman Ward',
            policeStationPostOffice: 'Nani Daman PS / PO 396210',
          ),
        ],
      },
      'Diu': {
        'Diu Town': [
          const VillageRecord(
            villageName: 'Ghoghla',
            lgdCode: '362501',
            gramPanchayat: 'Ghoghla GP',
            policeStationPostOffice: 'Diu PS / PO 362520',
          ),
          const VillageRecord(
            villageName: 'Fudam',
            lgdCode: '362502',
            gramPanchayat: 'Fudam GP',
            policeStationPostOffice: 'Diu PS / PO 362520',
          ),
        ],
      },
      'Dadra and Nagar Haveli': {
        'Silvassa': [
          const VillageRecord(
            villageName: 'Silvassa Urban',
            lgdCode: '396230',
            gramPanchayat: 'Silvassa Ward',
            policeStationPostOffice: 'Silvassa PS / PO 396230',
          ),
          const VillageRecord(
            villageName: 'Naroli',
            lgdCode: '396231',
            gramPanchayat: 'Naroli GP',
            policeStationPostOffice: 'Silvassa PS / PO 396235',
          ),
          const VillageRecord(
            villageName: 'Dadra',
            lgdCode: '396232',
            gramPanchayat: 'Dadra GP',
            policeStationPostOffice: 'Dadra PS / PO 396193',
          ),
        ],
      },
    },
    'Delhi': {
      'New Delhi': {
        'Chanakyapuri': [
          const VillageRecord(
            villageName: 'Chanakyapuri Area',
            lgdCode: '110001',
            gramPanchayat: 'NDMC Ward 1',
            policeStationPostOffice: 'Chanakyapuri PS / PO 110021',
          ),
          const VillageRecord(
            villageName: 'Connaught Place',
            lgdCode: '110002',
            gramPanchayat: 'NDMC Ward 2',
            policeStationPostOffice: 'Connaught Place PS / PO 110001',
          ),
        ],
      },
      'Central Delhi': {
        'Karol Bagh': [
          const VillageRecord(
            villageName: 'Karol Bagh Central',
            lgdCode: '110010',
            gramPanchayat: 'MCD Ward 82',
            policeStationPostOffice: 'Karol Bagh PS / PO 110005',
          ),
          const VillageRecord(
            villageName: 'Rajinder Nagar',
            lgdCode: '110011',
            gramPanchayat: 'MCD Ward 83',
            policeStationPostOffice: 'Rajinder Nagar PS / PO 110060',
          ),
        ],
      },
      'South Delhi': {
        'Hauz Khas': [
          const VillageRecord(
            villageName: 'Hauz Khas Village',
            lgdCode: '110020',
            gramPanchayat: 'MCD Ward 145',
            policeStationPostOffice: 'Hauz Khas PS / PO 110016',
          ),
          const VillageRecord(
            villageName: 'Green Park',
            lgdCode: '110021',
            gramPanchayat: 'MCD Ward 146',
            policeStationPostOffice: 'Safdarjung Enclave PS / PO 110016',
          ),
          const VillageRecord(
            villageName: 'Saket',
            lgdCode: '110022',
            gramPanchayat: 'MCD Ward 150',
            policeStationPostOffice: 'Saket PS / PO 110017',
          ),
        ],
        'Mehrauli': [
          const VillageRecord(
            villageName: 'Mehrauli Village',
            lgdCode: '110030',
            gramPanchayat: 'MCD Ward 152',
            policeStationPostOffice: 'Mehrauli PS / PO 110030',
          ),
        ],
      },
      'South West Delhi': {
        'Dwarka': [
          const VillageRecord(
            villageName: 'Dwarka Sector 10',
            lgdCode: '110040',
            gramPanchayat: 'MCD Ward 130',
            policeStationPostOffice: 'Dwarka South PS / PO 110075',
          ),
          const VillageRecord(
            villageName: 'Palam',
            lgdCode: '110041',
            gramPanchayat: 'MCD Ward 133',
            policeStationPostOffice: 'Palam Village PS / PO 110045',
          ),
          const VillageRecord(
            villageName: 'Najafgarh',
            lgdCode: '110042',
            gramPanchayat: 'MCD Ward 125',
            policeStationPostOffice: 'Najafgarh PS / PO 110043',
          ),
        ],
      },
      'North Delhi': {
        'Civil Lines': [
          const VillageRecord(
            villageName: 'Timarpur',
            lgdCode: '110050',
            gramPanchayat: 'MCD Ward 11',
            policeStationPostOffice: 'Timarpur PS / PO 110054',
          ),
          const VillageRecord(
            villageName: 'Burari',
            lgdCode: '110051',
            gramPanchayat: 'Burari GP',
            policeStationPostOffice: 'Burari PS / PO 110084',
          ),
        ],
        'Narela': [
          const VillageRecord(
            villageName: 'Narela Rural',
            lgdCode: '110060',
            gramPanchayat: 'Narela GP',
            policeStationPostOffice: 'Narela PS / PO 110040',
          ),
          const VillageRecord(
            villageName: 'Alipur',
            lgdCode: '110061',
            gramPanchayat: 'Alipur GP',
            policeStationPostOffice: 'Alipur PS / PO 110036',
          ),
        ],
      },
    },
    'Jammu and Kashmir': {
      'Srinagar': {
        'Srinagar City': [
          const VillageRecord(
            villageName: 'Lal Chowk',
            lgdCode: '190001',
            gramPanchayat: 'SMC Ward 1',
            policeStationPostOffice: 'Kothi Bagh PS / PO 190001',
          ),
          const VillageRecord(
            villageName: 'Hazratbal',
            lgdCode: '190002',
            gramPanchayat: 'SMC Ward 15',
            policeStationPostOffice: 'Nigeen PS / PO 190006',
          ),
          const VillageRecord(
            villageName: 'Soura',
            lgdCode: '190003',
            gramPanchayat: 'SMC Ward 20',
            policeStationPostOffice: 'Soura PS / PO 190011',
          ),
        ],
      },
      'Jammu': {
        'Jammu City': [
          const VillageRecord(
            villageName: 'Gandhi Nagar',
            lgdCode: '180001',
            gramPanchayat: 'JMC Ward 20',
            policeStationPostOffice: 'Gandhi Nagar PS / PO 180004',
          ),
          const VillageRecord(
            villageName: 'Channi Himmat',
            lgdCode: '180002',
            gramPanchayat: 'JMC Ward 49',
            policeStationPostOffice: 'Channi Himmat PS / PO 180015',
          ),
          const VillageRecord(
            villageName: 'Bahu Fort Area',
            lgdCode: '180003',
            gramPanchayat: 'JMC Ward 47',
            policeStationPostOffice: 'Bagh-e-Bahu PS / PO 180006',
          ),
        ],
        'R.S. Pura': [
          const VillageRecord(
            villageName: 'R.S. Pura Rural',
            lgdCode: '180010',
            gramPanchayat: 'R.S. Pura GP',
            policeStationPostOffice: 'R.S. Pura PS / PO 181102',
          ),
        ],
      },
      'Anantnag': {
        'Anantnag Town': [
          const VillageRecord(
            villageName: 'Khanabal',
            lgdCode: '192001',
            gramPanchayat: 'Anantnag Ward',
            policeStationPostOffice: 'Anantnag PS / PO 192101',
          ),
          const VillageRecord(
            villageName: 'Pahalgam',
            lgdCode: '192002',
            gramPanchayat: 'Pahalgam GP',
            policeStationPostOffice: 'Pahalgam PS / PO 192126',
          ),
        ],
      },
      'Baramulla': {
        'Baramulla Town': [
          const VillageRecord(
            villageName: 'Kanispora',
            lgdCode: '193001',
            gramPanchayat: 'Baramulla Ward',
            policeStationPostOffice: 'Baramulla PS / PO 193101',
          ),
          const VillageRecord(
            villageName: 'Sopore',
            lgdCode: '193002',
            gramPanchayat: 'Sopore Ward',
            policeStationPostOffice: 'Sopore PS / PO 193201',
          ),
        ],
      },
    },
    'Ladakh': {
      'Leh': {
        'Leh City': [
          const VillageRecord(
            villageName: 'Choglamsar',
            lgdCode: '194101',
            gramPanchayat: 'Choglamsar GP',
            policeStationPostOffice: 'Leh PS / PO 194104',
          ),
          const VillageRecord(
            villageName: 'Shey',
            lgdCode: '194102',
            gramPanchayat: 'Shey GP',
            policeStationPostOffice: 'Leh PS / PO 194201',
          ),
          const VillageRecord(
            villageName: 'Thiksay',
            lgdCode: '194103',
            gramPanchayat: 'Thiksay GP',
            policeStationPostOffice: 'Leh PS / PO 194201',
          ),
        ],
        'Nubra': [
          const VillageRecord(
            villageName: 'Diskit',
            lgdCode: '194110',
            gramPanchayat: 'Diskit GP',
            policeStationPostOffice: 'Diskit PS / PO 194401',
          ),
          const VillageRecord(
            villageName: 'Hunder',
            lgdCode: '194111',
            gramPanchayat: 'Hunder GP',
            policeStationPostOffice: 'Diskit PS / PO 194401',
          ),
        ],
      },
      'Kargil': {
        'Kargil Town': [
          const VillageRecord(
            villageName: 'Baroo',
            lgdCode: '194120',
            gramPanchayat: 'Baroo Ward',
            policeStationPostOffice: 'Kargil PS / PO 194103',
          ),
          const VillageRecord(
            villageName: 'Dras',
            lgdCode: '194121',
            gramPanchayat: 'Dras GP',
            policeStationPostOffice: 'Dras PS / PO 194102',
          ),
        ],
      },
    },
    'Lakshadweep': {
      'Lakshadweep': {
        'Kavaratti': [
          const VillageRecord(
            villageName: 'Kavaratti Island',
            lgdCode: '682555',
            gramPanchayat: 'Village Dweep Panchayat Kavaratti',
            policeStationPostOffice: 'Kavaratti PS / PO 682555',
          ),
        ],
        'Agatti': [
          const VillageRecord(
            villageName: 'Agatti Island',
            lgdCode: '682553',
            gramPanchayat: 'VDP Agatti',
            policeStationPostOffice: 'Agatti PS / PO 682553',
          ),
        ],
        'Minicoy': [
          const VillageRecord(
            villageName: 'Minicoy Island',
            lgdCode: '682559',
            gramPanchayat: 'VDP Minicoy',
            policeStationPostOffice: 'Minicoy PS / PO 682559',
          ),
        ],
        'Andrott': [
          const VillageRecord(
            villageName: 'Andrott Island',
            lgdCode: '682551',
            gramPanchayat: 'VDP Andrott',
            policeStationPostOffice: 'Andrott PS / PO 682551',
          ),
        ],
      },
    },
    'Puducherry': {
      'Puducherry': {
        'Puducherry Town': [
          const VillageRecord(
            villageName: 'White Town',
            lgdCode: '605001',
            gramPanchayat: 'Ward 1',
            policeStationPostOffice: 'Grand Bazaar PS / PO 605001',
          ),
          const VillageRecord(
            villageName: 'Lawspet',
            lgdCode: '605002',
            gramPanchayat: 'Lawspet Ward',
            policeStationPostOffice: 'Lawspet PS / PO 605008',
          ),
          const VillageRecord(
            villageName: 'Ozhukarai',
            lgdCode: '605003',
            gramPanchayat: 'Ozhukarai Municipality',
            policeStationPostOffice: 'D Nagar PS / PO 605009',
          ),
        ],
        'Villianur': [
          const VillageRecord(
            villageName: 'Villianur Town',
            lgdCode: '605010',
            gramPanchayat: 'Villianur Commune',
            policeStationPostOffice: 'Villianur PS / PO 605110',
          ),
          const VillageRecord(
            villageName: 'Bahour',
            lgdCode: '605011',
            gramPanchayat: 'Bahour Commune',
            policeStationPostOffice: 'Bahour PS / PO 607402',
          ),
        ],
      },
      'Karaikal': {
        'Karaikal Town': [
          const VillageRecord(
            villageName: 'Karaikal North',
            lgdCode: '609601',
            gramPanchayat: 'Ward 5',
            policeStationPostOffice: 'Town PS / PO 609602',
          ),
          const VillageRecord(
            villageName: 'Thirunallar',
            lgdCode: '609602',
            gramPanchayat: 'Thirunallar Commune',
            policeStationPostOffice: 'Thirunallar PS / PO 609607',
          ),
        ],
      },
    },
  };

  /// Returns sorted list of all States & Union Territories of India.
  static List<String> getStates() {
    return hierarchy.keys.toList()..sort();
  }

  /// Returns sorted list of all Districts for a given State.
  static List<String> getDistricts(String state) {
    if (!hierarchy.containsKey(state)) return [];
    return hierarchy[state]!.keys.toList()..sort();
  }

  /// Returns sorted list of all Cities/Blocks for a given District.
  static List<String> getCities(String state, String district) {
    return getBlocks(state, district);
  }

  /// Returns sorted list of all Blocks/Cities for backward compatibility.
  static List<String> getBlocks(String state, String district) {
    if (!hierarchy.containsKey(state)) return [];
    final districts = hierarchy[state]!;
    if (!districts.containsKey(district)) return [];
    return districts[district]!.keys.toList()..sort();
  }

  /// Returns list of VillageRecord items for a given State, District, and City/Block.
  static List<VillageRecord> getVillages(String state, String district, String cityOrBlock) {
    if (!hierarchy.containsKey(state)) return [];
    final districts = hierarchy[state]!;
    if (!districts.containsKey(district)) return [];
    final blocks = districts[district]!;
    if (!blocks.containsKey(cityOrBlock)) return [];
    return blocks[cityOrBlock]!;
  }

  /// Finds a specific VillageRecord matching villageName in the given hierarchy.
  static VillageRecord? findVillage(String state, String district, String cityOrBlock, String villageName) {
    final list = getVillages(state, district, cityOrBlock);
    for (final v in list) {
      if (v.villageName.toLowerCase() == villageName.toLowerCase()) {
        return v;
      }
    }
    return null;
  }
}
