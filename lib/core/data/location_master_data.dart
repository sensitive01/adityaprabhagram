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
      'Alluri Sitharama Raju': {

        'Alluri Sitharama Raju City': [
          const VillageRecord(
            villageName: 'Alluri Sitharama Raju Rural',
            lgdCode: '500002',
            gramPanchayat: 'Alluri Sitharama Raju GP',
            policeStationPostOffice: 'Alluri Sitharama Raju PS / PO',
          ),
          const VillageRecord(
            villageName: 'Alluri Sitharama Raju North',
            lgdCode: '500003',
            gramPanchayat: 'Alluri Sitharama Raju Ward 1',
            policeStationPostOffice: 'Alluri Sitharama Raju PS / PO',
          ),
        ],
        'Alluri Sitharama Raju Block': [
          const VillageRecord(
            villageName: 'Alluri Sitharama Raju East',
            lgdCode: '500004',
            gramPanchayat: 'Alluri Sitharama Raju East GP',
            policeStationPostOffice: 'Alluri Sitharama Raju Rural PS',
          ),
          const VillageRecord(
            villageName: 'Alluri Sitharama Raju South',
            lgdCode: '500005',
            gramPanchayat: 'Alluri Sitharama Raju South GP',
            policeStationPostOffice: 'Alluri Sitharama Raju Rural PS',
          ),
        ],
      },
      'Anakapalli': {

        'Anakapalli City': [
          const VillageRecord(
            villageName: 'Anakapalli Rural',
            lgdCode: '500006',
            gramPanchayat: 'Anakapalli GP',
            policeStationPostOffice: 'Anakapalli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Anakapalli North',
            lgdCode: '500007',
            gramPanchayat: 'Anakapalli Ward 1',
            policeStationPostOffice: 'Anakapalli PS / PO',
          ),
        ],
        'Anakapalli Block': [
          const VillageRecord(
            villageName: 'Anakapalli East',
            lgdCode: '500008',
            gramPanchayat: 'Anakapalli East GP',
            policeStationPostOffice: 'Anakapalli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Anakapalli South',
            lgdCode: '500009',
            gramPanchayat: 'Anakapalli South GP',
            policeStationPostOffice: 'Anakapalli Rural PS',
          ),
        ],
      },
      'Ananthapuramu': {

        'Ananthapuramu City': [
          const VillageRecord(
            villageName: 'Ananthapuramu Rural',
            lgdCode: '500010',
            gramPanchayat: 'Ananthapuramu GP',
            policeStationPostOffice: 'Ananthapuramu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ananthapuramu North',
            lgdCode: '500011',
            gramPanchayat: 'Ananthapuramu Ward 1',
            policeStationPostOffice: 'Ananthapuramu PS / PO',
          ),
        ],
        'Ananthapuramu Block': [
          const VillageRecord(
            villageName: 'Ananthapuramu East',
            lgdCode: '500012',
            gramPanchayat: 'Ananthapuramu East GP',
            policeStationPostOffice: 'Ananthapuramu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ananthapuramu South',
            lgdCode: '500013',
            gramPanchayat: 'Ananthapuramu South GP',
            policeStationPostOffice: 'Ananthapuramu Rural PS',
          ),
        ],
      },
      'Annamayya': {

        'Annamayya City': [
          const VillageRecord(
            villageName: 'Annamayya Rural',
            lgdCode: '500014',
            gramPanchayat: 'Annamayya GP',
            policeStationPostOffice: 'Annamayya PS / PO',
          ),
          const VillageRecord(
            villageName: 'Annamayya North',
            lgdCode: '500015',
            gramPanchayat: 'Annamayya Ward 1',
            policeStationPostOffice: 'Annamayya PS / PO',
          ),
        ],
        'Annamayya Block': [
          const VillageRecord(
            villageName: 'Annamayya East',
            lgdCode: '500016',
            gramPanchayat: 'Annamayya East GP',
            policeStationPostOffice: 'Annamayya Rural PS',
          ),
          const VillageRecord(
            villageName: 'Annamayya South',
            lgdCode: '500017',
            gramPanchayat: 'Annamayya South GP',
            policeStationPostOffice: 'Annamayya Rural PS',
          ),
        ],
      },
      'Bapatla': {

        'Bapatla City': [
          const VillageRecord(
            villageName: 'Bapatla Rural',
            lgdCode: '500018',
            gramPanchayat: 'Bapatla GP',
            policeStationPostOffice: 'Bapatla PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bapatla North',
            lgdCode: '500019',
            gramPanchayat: 'Bapatla Ward 1',
            policeStationPostOffice: 'Bapatla PS / PO',
          ),
        ],
        'Bapatla Block': [
          const VillageRecord(
            villageName: 'Bapatla East',
            lgdCode: '500020',
            gramPanchayat: 'Bapatla East GP',
            policeStationPostOffice: 'Bapatla Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bapatla South',
            lgdCode: '500021',
            gramPanchayat: 'Bapatla South GP',
            policeStationPostOffice: 'Bapatla Rural PS',
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
      'Dr. B.R. Ambedkar Konaseema': {

        'Dr. B.R. Ambedkar Konaseema City': [
          const VillageRecord(
            villageName: 'Dr. B.R. Ambedkar Konaseema Rural',
            lgdCode: '500022',
            gramPanchayat: 'Dr. B.R. Ambedkar Konaseema GP',
            policeStationPostOffice: 'Dr. B.R. Ambedkar Konaseema PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dr. B.R. Ambedkar Konaseema North',
            lgdCode: '500023',
            gramPanchayat: 'Dr. B.R. Ambedkar Konaseema Ward 1',
            policeStationPostOffice: 'Dr. B.R. Ambedkar Konaseema PS / PO',
          ),
        ],
        'Dr. B.R. Ambedkar Konaseema Block': [
          const VillageRecord(
            villageName: 'Dr. B.R. Ambedkar Konaseema East',
            lgdCode: '500024',
            gramPanchayat: 'Dr. B.R. Ambedkar Konaseema East GP',
            policeStationPostOffice: 'Dr. B.R. Ambedkar Konaseema Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dr. B.R. Ambedkar Konaseema South',
            lgdCode: '500025',
            gramPanchayat: 'Dr. B.R. Ambedkar Konaseema South GP',
            policeStationPostOffice: 'Dr. B.R. Ambedkar Konaseema Rural PS',
          ),
        ],
      },
      'East Godavari': {

        'East Godavari City': [
          const VillageRecord(
            villageName: 'East Godavari Rural',
            lgdCode: '500026',
            gramPanchayat: 'East Godavari GP',
            policeStationPostOffice: 'East Godavari PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Godavari North',
            lgdCode: '500027',
            gramPanchayat: 'East Godavari Ward 1',
            policeStationPostOffice: 'East Godavari PS / PO',
          ),
        ],
        'East Godavari Block': [
          const VillageRecord(
            villageName: 'East Godavari East',
            lgdCode: '500028',
            gramPanchayat: 'East Godavari East GP',
            policeStationPostOffice: 'East Godavari Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Godavari South',
            lgdCode: '500029',
            gramPanchayat: 'East Godavari South GP',
            policeStationPostOffice: 'East Godavari Rural PS',
          ),
        ],
      },
      'Eluru': {

        'Eluru City': [
          const VillageRecord(
            villageName: 'Eluru Rural',
            lgdCode: '500030',
            gramPanchayat: 'Eluru GP',
            policeStationPostOffice: 'Eluru PS / PO',
          ),
          const VillageRecord(
            villageName: 'Eluru North',
            lgdCode: '500031',
            gramPanchayat: 'Eluru Ward 1',
            policeStationPostOffice: 'Eluru PS / PO',
          ),
        ],
        'Eluru Block': [
          const VillageRecord(
            villageName: 'Eluru East',
            lgdCode: '500032',
            gramPanchayat: 'Eluru East GP',
            policeStationPostOffice: 'Eluru Rural PS',
          ),
          const VillageRecord(
            villageName: 'Eluru South',
            lgdCode: '500033',
            gramPanchayat: 'Eluru South GP',
            policeStationPostOffice: 'Eluru Rural PS',
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
      'Kakinada': {

        'Kakinada City': [
          const VillageRecord(
            villageName: 'Kakinada Rural',
            lgdCode: '500034',
            gramPanchayat: 'Kakinada GP',
            policeStationPostOffice: 'Kakinada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kakinada North',
            lgdCode: '500035',
            gramPanchayat: 'Kakinada Ward 1',
            policeStationPostOffice: 'Kakinada PS / PO',
          ),
        ],
        'Kakinada Block': [
          const VillageRecord(
            villageName: 'Kakinada East',
            lgdCode: '500036',
            gramPanchayat: 'Kakinada East GP',
            policeStationPostOffice: 'Kakinada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kakinada South',
            lgdCode: '500037',
            gramPanchayat: 'Kakinada South GP',
            policeStationPostOffice: 'Kakinada Rural PS',
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
      'Kurnool': {

        'Kurnool City': [
          const VillageRecord(
            villageName: 'Kurnool Rural',
            lgdCode: '500038',
            gramPanchayat: 'Kurnool GP',
            policeStationPostOffice: 'Kurnool PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kurnool North',
            lgdCode: '500039',
            gramPanchayat: 'Kurnool Ward 1',
            policeStationPostOffice: 'Kurnool PS / PO',
          ),
        ],
        'Kurnool Block': [
          const VillageRecord(
            villageName: 'Kurnool East',
            lgdCode: '500040',
            gramPanchayat: 'Kurnool East GP',
            policeStationPostOffice: 'Kurnool Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kurnool South',
            lgdCode: '500041',
            gramPanchayat: 'Kurnool South GP',
            policeStationPostOffice: 'Kurnool Rural PS',
          ),
        ],
      },
      'Nandyal': {

        'Nandyal City': [
          const VillageRecord(
            villageName: 'Nandyal Rural',
            lgdCode: '500042',
            gramPanchayat: 'Nandyal GP',
            policeStationPostOffice: 'Nandyal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nandyal North',
            lgdCode: '500043',
            gramPanchayat: 'Nandyal Ward 1',
            policeStationPostOffice: 'Nandyal PS / PO',
          ),
        ],
        'Nandyal Block': [
          const VillageRecord(
            villageName: 'Nandyal East',
            lgdCode: '500044',
            gramPanchayat: 'Nandyal East GP',
            policeStationPostOffice: 'Nandyal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nandyal South',
            lgdCode: '500045',
            gramPanchayat: 'Nandyal South GP',
            policeStationPostOffice: 'Nandyal Rural PS',
          ),
        ],
      },
      'NTR': {

        'NTR City': [
          const VillageRecord(
            villageName: 'NTR Rural',
            lgdCode: '500046',
            gramPanchayat: 'NTR GP',
            policeStationPostOffice: 'NTR PS / PO',
          ),
          const VillageRecord(
            villageName: 'NTR North',
            lgdCode: '500047',
            gramPanchayat: 'NTR Ward 1',
            policeStationPostOffice: 'NTR PS / PO',
          ),
        ],
        'NTR Block': [
          const VillageRecord(
            villageName: 'NTR East',
            lgdCode: '500048',
            gramPanchayat: 'NTR East GP',
            policeStationPostOffice: 'NTR Rural PS',
          ),
          const VillageRecord(
            villageName: 'NTR South',
            lgdCode: '500049',
            gramPanchayat: 'NTR South GP',
            policeStationPostOffice: 'NTR Rural PS',
          ),
        ],
      },
      'Palnadu': {

        'Palnadu City': [
          const VillageRecord(
            villageName: 'Palnadu Rural',
            lgdCode: '500050',
            gramPanchayat: 'Palnadu GP',
            policeStationPostOffice: 'Palnadu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Palnadu North',
            lgdCode: '500051',
            gramPanchayat: 'Palnadu Ward 1',
            policeStationPostOffice: 'Palnadu PS / PO',
          ),
        ],
        'Palnadu Block': [
          const VillageRecord(
            villageName: 'Palnadu East',
            lgdCode: '500052',
            gramPanchayat: 'Palnadu East GP',
            policeStationPostOffice: 'Palnadu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Palnadu South',
            lgdCode: '500053',
            gramPanchayat: 'Palnadu South GP',
            policeStationPostOffice: 'Palnadu Rural PS',
          ),
        ],
      },
      'Parvathipuram Manyam': {

        'Parvathipuram Manyam City': [
          const VillageRecord(
            villageName: 'Parvathipuram Manyam Rural',
            lgdCode: '500054',
            gramPanchayat: 'Parvathipuram Manyam GP',
            policeStationPostOffice: 'Parvathipuram Manyam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Parvathipuram Manyam North',
            lgdCode: '500055',
            gramPanchayat: 'Parvathipuram Manyam Ward 1',
            policeStationPostOffice: 'Parvathipuram Manyam PS / PO',
          ),
        ],
        'Parvathipuram Manyam Block': [
          const VillageRecord(
            villageName: 'Parvathipuram Manyam East',
            lgdCode: '500056',
            gramPanchayat: 'Parvathipuram Manyam East GP',
            policeStationPostOffice: 'Parvathipuram Manyam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Parvathipuram Manyam South',
            lgdCode: '500057',
            gramPanchayat: 'Parvathipuram Manyam South GP',
            policeStationPostOffice: 'Parvathipuram Manyam Rural PS',
          ),
        ],
      },
      'Prakasam': {

        'Prakasam City': [
          const VillageRecord(
            villageName: 'Prakasam Rural',
            lgdCode: '500058',
            gramPanchayat: 'Prakasam GP',
            policeStationPostOffice: 'Prakasam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Prakasam North',
            lgdCode: '500059',
            gramPanchayat: 'Prakasam Ward 1',
            policeStationPostOffice: 'Prakasam PS / PO',
          ),
        ],
        'Prakasam Block': [
          const VillageRecord(
            villageName: 'Prakasam East',
            lgdCode: '500060',
            gramPanchayat: 'Prakasam East GP',
            policeStationPostOffice: 'Prakasam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Prakasam South',
            lgdCode: '500061',
            gramPanchayat: 'Prakasam South GP',
            policeStationPostOffice: 'Prakasam Rural PS',
          ),
        ],
      },
      'Sri Potti Sriramulu Nellore': {

        'Sri Potti Sriramulu Nellore City': [
          const VillageRecord(
            villageName: 'Sri Potti Sriramulu Nellore Rural',
            lgdCode: '500062',
            gramPanchayat: 'Sri Potti Sriramulu Nellore GP',
            policeStationPostOffice: 'Sri Potti Sriramulu Nellore PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sri Potti Sriramulu Nellore North',
            lgdCode: '500063',
            gramPanchayat: 'Sri Potti Sriramulu Nellore Ward 1',
            policeStationPostOffice: 'Sri Potti Sriramulu Nellore PS / PO',
          ),
        ],
        'Sri Potti Sriramulu Nellore Block': [
          const VillageRecord(
            villageName: 'Sri Potti Sriramulu Nellore East',
            lgdCode: '500064',
            gramPanchayat: 'Sri Potti Sriramulu Nellore East GP',
            policeStationPostOffice: 'Sri Potti Sriramulu Nellore Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sri Potti Sriramulu Nellore South',
            lgdCode: '500065',
            gramPanchayat: 'Sri Potti Sriramulu Nellore South GP',
            policeStationPostOffice: 'Sri Potti Sriramulu Nellore Rural PS',
          ),
        ],
      },
      'Sri Sathya Sai': {

        'Sri Sathya Sai City': [
          const VillageRecord(
            villageName: 'Sri Sathya Sai Rural',
            lgdCode: '500066',
            gramPanchayat: 'Sri Sathya Sai GP',
            policeStationPostOffice: 'Sri Sathya Sai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sri Sathya Sai North',
            lgdCode: '500067',
            gramPanchayat: 'Sri Sathya Sai Ward 1',
            policeStationPostOffice: 'Sri Sathya Sai PS / PO',
          ),
        ],
        'Sri Sathya Sai Block': [
          const VillageRecord(
            villageName: 'Sri Sathya Sai East',
            lgdCode: '500068',
            gramPanchayat: 'Sri Sathya Sai East GP',
            policeStationPostOffice: 'Sri Sathya Sai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sri Sathya Sai South',
            lgdCode: '500069',
            gramPanchayat: 'Sri Sathya Sai South GP',
            policeStationPostOffice: 'Sri Sathya Sai Rural PS',
          ),
        ],
      },
      'Srikakulam': {

        'Srikakulam City': [
          const VillageRecord(
            villageName: 'Srikakulam Rural',
            lgdCode: '500070',
            gramPanchayat: 'Srikakulam GP',
            policeStationPostOffice: 'Srikakulam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Srikakulam North',
            lgdCode: '500071',
            gramPanchayat: 'Srikakulam Ward 1',
            policeStationPostOffice: 'Srikakulam PS / PO',
          ),
        ],
        'Srikakulam Block': [
          const VillageRecord(
            villageName: 'Srikakulam East',
            lgdCode: '500072',
            gramPanchayat: 'Srikakulam East GP',
            policeStationPostOffice: 'Srikakulam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Srikakulam South',
            lgdCode: '500073',
            gramPanchayat: 'Srikakulam South GP',
            policeStationPostOffice: 'Srikakulam Rural PS',
          ),
        ],
      },
      'Tirupati': {

        'Tirupati City': [
          const VillageRecord(
            villageName: 'Tirupati Rural',
            lgdCode: '500074',
            gramPanchayat: 'Tirupati GP',
            policeStationPostOffice: 'Tirupati PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tirupati North',
            lgdCode: '500075',
            gramPanchayat: 'Tirupati Ward 1',
            policeStationPostOffice: 'Tirupati PS / PO',
          ),
        ],
        'Tirupati Block': [
          const VillageRecord(
            villageName: 'Tirupati East',
            lgdCode: '500076',
            gramPanchayat: 'Tirupati East GP',
            policeStationPostOffice: 'Tirupati Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tirupati South',
            lgdCode: '500077',
            gramPanchayat: 'Tirupati South GP',
            policeStationPostOffice: 'Tirupati Rural PS',
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
      'Vizianagaram': {

        'Vizianagaram City': [
          const VillageRecord(
            villageName: 'Vizianagaram Rural',
            lgdCode: '500078',
            gramPanchayat: 'Vizianagaram GP',
            policeStationPostOffice: 'Vizianagaram PS / PO',
          ),
          const VillageRecord(
            villageName: 'Vizianagaram North',
            lgdCode: '500079',
            gramPanchayat: 'Vizianagaram Ward 1',
            policeStationPostOffice: 'Vizianagaram PS / PO',
          ),
        ],
        'Vizianagaram Block': [
          const VillageRecord(
            villageName: 'Vizianagaram East',
            lgdCode: '500080',
            gramPanchayat: 'Vizianagaram East GP',
            policeStationPostOffice: 'Vizianagaram Rural PS',
          ),
          const VillageRecord(
            villageName: 'Vizianagaram South',
            lgdCode: '500081',
            gramPanchayat: 'Vizianagaram South GP',
            policeStationPostOffice: 'Vizianagaram Rural PS',
          ),
        ],
      },
      'West Godavari': {

        'West Godavari City': [
          const VillageRecord(
            villageName: 'West Godavari Rural',
            lgdCode: '500082',
            gramPanchayat: 'West Godavari GP',
            policeStationPostOffice: 'West Godavari PS / PO',
          ),
          const VillageRecord(
            villageName: 'West Godavari North',
            lgdCode: '500083',
            gramPanchayat: 'West Godavari Ward 1',
            policeStationPostOffice: 'West Godavari PS / PO',
          ),
        ],
        'West Godavari Block': [
          const VillageRecord(
            villageName: 'West Godavari East',
            lgdCode: '500084',
            gramPanchayat: 'West Godavari East GP',
            policeStationPostOffice: 'West Godavari Rural PS',
          ),
          const VillageRecord(
            villageName: 'West Godavari South',
            lgdCode: '500085',
            gramPanchayat: 'West Godavari South GP',
            policeStationPostOffice: 'West Godavari Rural PS',
          ),
        ],
      },
      'YSR Kadapa': {

        'YSR Kadapa City': [
          const VillageRecord(
            villageName: 'YSR Kadapa Rural',
            lgdCode: '500086',
            gramPanchayat: 'YSR Kadapa GP',
            policeStationPostOffice: 'YSR Kadapa PS / PO',
          ),
          const VillageRecord(
            villageName: 'YSR Kadapa North',
            lgdCode: '500087',
            gramPanchayat: 'YSR Kadapa Ward 1',
            policeStationPostOffice: 'YSR Kadapa PS / PO',
          ),
        ],
        'YSR Kadapa Block': [
          const VillageRecord(
            villageName: 'YSR Kadapa East',
            lgdCode: '500088',
            gramPanchayat: 'YSR Kadapa East GP',
            policeStationPostOffice: 'YSR Kadapa Rural PS',
          ),
          const VillageRecord(
            villageName: 'YSR Kadapa South',
            lgdCode: '500089',
            gramPanchayat: 'YSR Kadapa South GP',
            policeStationPostOffice: 'YSR Kadapa Rural PS',
          ),
        ],
      },
    },
    'Arunachal Pradesh': {
      'Anjaw': {

        'Anjaw City': [
          const VillageRecord(
            villageName: 'Anjaw Rural',
            lgdCode: '500090',
            gramPanchayat: 'Anjaw GP',
            policeStationPostOffice: 'Anjaw PS / PO',
          ),
          const VillageRecord(
            villageName: 'Anjaw North',
            lgdCode: '500091',
            gramPanchayat: 'Anjaw Ward 1',
            policeStationPostOffice: 'Anjaw PS / PO',
          ),
        ],
        'Anjaw Block': [
          const VillageRecord(
            villageName: 'Anjaw East',
            lgdCode: '500092',
            gramPanchayat: 'Anjaw East GP',
            policeStationPostOffice: 'Anjaw Rural PS',
          ),
          const VillageRecord(
            villageName: 'Anjaw South',
            lgdCode: '500093',
            gramPanchayat: 'Anjaw South GP',
            policeStationPostOffice: 'Anjaw Rural PS',
          ),
        ],
      },
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
      'Dibang Valley': {

        'Dibang Valley City': [
          const VillageRecord(
            villageName: 'Dibang Valley Rural',
            lgdCode: '500094',
            gramPanchayat: 'Dibang Valley GP',
            policeStationPostOffice: 'Dibang Valley PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dibang Valley North',
            lgdCode: '500095',
            gramPanchayat: 'Dibang Valley Ward 1',
            policeStationPostOffice: 'Dibang Valley PS / PO',
          ),
        ],
        'Dibang Valley Block': [
          const VillageRecord(
            villageName: 'Dibang Valley East',
            lgdCode: '500096',
            gramPanchayat: 'Dibang Valley East GP',
            policeStationPostOffice: 'Dibang Valley Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dibang Valley South',
            lgdCode: '500097',
            gramPanchayat: 'Dibang Valley South GP',
            policeStationPostOffice: 'Dibang Valley Rural PS',
          ),
        ],
      },
      'East Kameng': {

        'East Kameng City': [
          const VillageRecord(
            villageName: 'East Kameng Rural',
            lgdCode: '500098',
            gramPanchayat: 'East Kameng GP',
            policeStationPostOffice: 'East Kameng PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Kameng North',
            lgdCode: '500099',
            gramPanchayat: 'East Kameng Ward 1',
            policeStationPostOffice: 'East Kameng PS / PO',
          ),
        ],
        'East Kameng Block': [
          const VillageRecord(
            villageName: 'East Kameng East',
            lgdCode: '500100',
            gramPanchayat: 'East Kameng East GP',
            policeStationPostOffice: 'East Kameng Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Kameng South',
            lgdCode: '500101',
            gramPanchayat: 'East Kameng South GP',
            policeStationPostOffice: 'East Kameng Rural PS',
          ),
        ],
      },
      'East Siang': {

        'East Siang City': [
          const VillageRecord(
            villageName: 'East Siang Rural',
            lgdCode: '500102',
            gramPanchayat: 'East Siang GP',
            policeStationPostOffice: 'East Siang PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Siang North',
            lgdCode: '500103',
            gramPanchayat: 'East Siang Ward 1',
            policeStationPostOffice: 'East Siang PS / PO',
          ),
        ],
        'East Siang Block': [
          const VillageRecord(
            villageName: 'East Siang East',
            lgdCode: '500104',
            gramPanchayat: 'East Siang East GP',
            policeStationPostOffice: 'East Siang Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Siang South',
            lgdCode: '500105',
            gramPanchayat: 'East Siang South GP',
            policeStationPostOffice: 'East Siang Rural PS',
          ),
        ],
      },
      'Kamle': {

        'Kamle City': [
          const VillageRecord(
            villageName: 'Kamle Rural',
            lgdCode: '500106',
            gramPanchayat: 'Kamle GP',
            policeStationPostOffice: 'Kamle PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kamle North',
            lgdCode: '500107',
            gramPanchayat: 'Kamle Ward 1',
            policeStationPostOffice: 'Kamle PS / PO',
          ),
        ],
        'Kamle Block': [
          const VillageRecord(
            villageName: 'Kamle East',
            lgdCode: '500108',
            gramPanchayat: 'Kamle East GP',
            policeStationPostOffice: 'Kamle Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kamle South',
            lgdCode: '500109',
            gramPanchayat: 'Kamle South GP',
            policeStationPostOffice: 'Kamle Rural PS',
          ),
        ],
      },
      'Kra Daadi': {

        'Kra Daadi City': [
          const VillageRecord(
            villageName: 'Kra Daadi Rural',
            lgdCode: '500110',
            gramPanchayat: 'Kra Daadi GP',
            policeStationPostOffice: 'Kra Daadi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kra Daadi North',
            lgdCode: '500111',
            gramPanchayat: 'Kra Daadi Ward 1',
            policeStationPostOffice: 'Kra Daadi PS / PO',
          ),
        ],
        'Kra Daadi Block': [
          const VillageRecord(
            villageName: 'Kra Daadi East',
            lgdCode: '500112',
            gramPanchayat: 'Kra Daadi East GP',
            policeStationPostOffice: 'Kra Daadi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kra Daadi South',
            lgdCode: '500113',
            gramPanchayat: 'Kra Daadi South GP',
            policeStationPostOffice: 'Kra Daadi Rural PS',
          ),
        ],
      },
      'Kurung Kumey': {

        'Kurung Kumey City': [
          const VillageRecord(
            villageName: 'Kurung Kumey Rural',
            lgdCode: '500114',
            gramPanchayat: 'Kurung Kumey GP',
            policeStationPostOffice: 'Kurung Kumey PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kurung Kumey North',
            lgdCode: '500115',
            gramPanchayat: 'Kurung Kumey Ward 1',
            policeStationPostOffice: 'Kurung Kumey PS / PO',
          ),
        ],
        'Kurung Kumey Block': [
          const VillageRecord(
            villageName: 'Kurung Kumey East',
            lgdCode: '500116',
            gramPanchayat: 'Kurung Kumey East GP',
            policeStationPostOffice: 'Kurung Kumey Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kurung Kumey South',
            lgdCode: '500117',
            gramPanchayat: 'Kurung Kumey South GP',
            policeStationPostOffice: 'Kurung Kumey Rural PS',
          ),
        ],
      },
      'Lepa Rada': {

        'Lepa Rada City': [
          const VillageRecord(
            villageName: 'Lepa Rada Rural',
            lgdCode: '500118',
            gramPanchayat: 'Lepa Rada GP',
            policeStationPostOffice: 'Lepa Rada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lepa Rada North',
            lgdCode: '500119',
            gramPanchayat: 'Lepa Rada Ward 1',
            policeStationPostOffice: 'Lepa Rada PS / PO',
          ),
        ],
        'Lepa Rada Block': [
          const VillageRecord(
            villageName: 'Lepa Rada East',
            lgdCode: '500120',
            gramPanchayat: 'Lepa Rada East GP',
            policeStationPostOffice: 'Lepa Rada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lepa Rada South',
            lgdCode: '500121',
            gramPanchayat: 'Lepa Rada South GP',
            policeStationPostOffice: 'Lepa Rada Rural PS',
          ),
        ],
      },
      'Lohit': {

        'Lohit City': [
          const VillageRecord(
            villageName: 'Lohit Rural',
            lgdCode: '500122',
            gramPanchayat: 'Lohit GP',
            policeStationPostOffice: 'Lohit PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lohit North',
            lgdCode: '500123',
            gramPanchayat: 'Lohit Ward 1',
            policeStationPostOffice: 'Lohit PS / PO',
          ),
        ],
        'Lohit Block': [
          const VillageRecord(
            villageName: 'Lohit East',
            lgdCode: '500124',
            gramPanchayat: 'Lohit East GP',
            policeStationPostOffice: 'Lohit Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lohit South',
            lgdCode: '500125',
            gramPanchayat: 'Lohit South GP',
            policeStationPostOffice: 'Lohit Rural PS',
          ),
        ],
      },
      'Longding': {

        'Longding City': [
          const VillageRecord(
            villageName: 'Longding Rural',
            lgdCode: '500126',
            gramPanchayat: 'Longding GP',
            policeStationPostOffice: 'Longding PS / PO',
          ),
          const VillageRecord(
            villageName: 'Longding North',
            lgdCode: '500127',
            gramPanchayat: 'Longding Ward 1',
            policeStationPostOffice: 'Longding PS / PO',
          ),
        ],
        'Longding Block': [
          const VillageRecord(
            villageName: 'Longding East',
            lgdCode: '500128',
            gramPanchayat: 'Longding East GP',
            policeStationPostOffice: 'Longding Rural PS',
          ),
          const VillageRecord(
            villageName: 'Longding South',
            lgdCode: '500129',
            gramPanchayat: 'Longding South GP',
            policeStationPostOffice: 'Longding Rural PS',
          ),
        ],
      },
      'Lower Dibang Valley': {

        'Dibang Valley City': [
          const VillageRecord(
            villageName: 'Dibang Valley Rural',
            lgdCode: '500094',
            gramPanchayat: 'Dibang Valley GP',
            policeStationPostOffice: 'Dibang Valley PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dibang Valley North',
            lgdCode: '500095',
            gramPanchayat: 'Dibang Valley Ward 1',
            policeStationPostOffice: 'Dibang Valley PS / PO',
          ),
        ],
        'Dibang Valley Block': [
          const VillageRecord(
            villageName: 'Dibang Valley East',
            lgdCode: '500096',
            gramPanchayat: 'Dibang Valley East GP',
            policeStationPostOffice: 'Dibang Valley Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dibang Valley South',
            lgdCode: '500097',
            gramPanchayat: 'Dibang Valley South GP',
            policeStationPostOffice: 'Dibang Valley Rural PS',
          ),
        ],
      },
      'Lower Siang': {

        'Lower Siang City': [
          const VillageRecord(
            villageName: 'Lower Siang Rural',
            lgdCode: '500134',
            gramPanchayat: 'Lower Siang GP',
            policeStationPostOffice: 'Lower Siang PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lower Siang North',
            lgdCode: '500135',
            gramPanchayat: 'Lower Siang Ward 1',
            policeStationPostOffice: 'Lower Siang PS / PO',
          ),
        ],
        'Lower Siang Block': [
          const VillageRecord(
            villageName: 'Lower Siang East',
            lgdCode: '500136',
            gramPanchayat: 'Lower Siang East GP',
            policeStationPostOffice: 'Lower Siang Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lower Siang South',
            lgdCode: '500137',
            gramPanchayat: 'Lower Siang South GP',
            policeStationPostOffice: 'Lower Siang Rural PS',
          ),
        ],
      },
      'Lower Subansiri': {

        'Lower Subansiri City': [
          const VillageRecord(
            villageName: 'Lower Subansiri Rural',
            lgdCode: '500138',
            gramPanchayat: 'Lower Subansiri GP',
            policeStationPostOffice: 'Lower Subansiri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lower Subansiri North',
            lgdCode: '500139',
            gramPanchayat: 'Lower Subansiri Ward 1',
            policeStationPostOffice: 'Lower Subansiri PS / PO',
          ),
        ],
        'Lower Subansiri Block': [
          const VillageRecord(
            villageName: 'Lower Subansiri East',
            lgdCode: '500140',
            gramPanchayat: 'Lower Subansiri East GP',
            policeStationPostOffice: 'Lower Subansiri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lower Subansiri South',
            lgdCode: '500141',
            gramPanchayat: 'Lower Subansiri South GP',
            policeStationPostOffice: 'Lower Subansiri Rural PS',
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
      'Pakke Kessang': {

        'Pakke Kessang City': [
          const VillageRecord(
            villageName: 'Pakke Kessang Rural',
            lgdCode: '500142',
            gramPanchayat: 'Pakke Kessang GP',
            policeStationPostOffice: 'Pakke Kessang PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pakke Kessang North',
            lgdCode: '500143',
            gramPanchayat: 'Pakke Kessang Ward 1',
            policeStationPostOffice: 'Pakke Kessang PS / PO',
          ),
        ],
        'Pakke Kessang Block': [
          const VillageRecord(
            villageName: 'Pakke Kessang East',
            lgdCode: '500144',
            gramPanchayat: 'Pakke Kessang East GP',
            policeStationPostOffice: 'Pakke Kessang Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pakke Kessang South',
            lgdCode: '500145',
            gramPanchayat: 'Pakke Kessang South GP',
            policeStationPostOffice: 'Pakke Kessang Rural PS',
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
      'Shi Yomi': {

        'Shi Yomi City': [
          const VillageRecord(
            villageName: 'Shi Yomi Rural',
            lgdCode: '500146',
            gramPanchayat: 'Shi Yomi GP',
            policeStationPostOffice: 'Shi Yomi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shi Yomi North',
            lgdCode: '500147',
            gramPanchayat: 'Shi Yomi Ward 1',
            policeStationPostOffice: 'Shi Yomi PS / PO',
          ),
        ],
        'Shi Yomi Block': [
          const VillageRecord(
            villageName: 'Shi Yomi East',
            lgdCode: '500148',
            gramPanchayat: 'Shi Yomi East GP',
            policeStationPostOffice: 'Shi Yomi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shi Yomi South',
            lgdCode: '500149',
            gramPanchayat: 'Shi Yomi South GP',
            policeStationPostOffice: 'Shi Yomi Rural PS',
          ),
        ],
      },
      'Siang': {

        'East Siang City': [
          const VillageRecord(
            villageName: 'East Siang Rural',
            lgdCode: '500102',
            gramPanchayat: 'East Siang GP',
            policeStationPostOffice: 'East Siang PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Siang North',
            lgdCode: '500103',
            gramPanchayat: 'East Siang Ward 1',
            policeStationPostOffice: 'East Siang PS / PO',
          ),
        ],
        'East Siang Block': [
          const VillageRecord(
            villageName: 'East Siang East',
            lgdCode: '500104',
            gramPanchayat: 'East Siang East GP',
            policeStationPostOffice: 'East Siang Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Siang South',
            lgdCode: '500105',
            gramPanchayat: 'East Siang South GP',
            policeStationPostOffice: 'East Siang Rural PS',
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
      'Tirap': {

        'Tirap City': [
          const VillageRecord(
            villageName: 'Tirap Rural',
            lgdCode: '500154',
            gramPanchayat: 'Tirap GP',
            policeStationPostOffice: 'Tirap PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tirap North',
            lgdCode: '500155',
            gramPanchayat: 'Tirap Ward 1',
            policeStationPostOffice: 'Tirap PS / PO',
          ),
        ],
        'Tirap Block': [
          const VillageRecord(
            villageName: 'Tirap East',
            lgdCode: '500156',
            gramPanchayat: 'Tirap East GP',
            policeStationPostOffice: 'Tirap Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tirap South',
            lgdCode: '500157',
            gramPanchayat: 'Tirap South GP',
            policeStationPostOffice: 'Tirap Rural PS',
          ),
        ],
      },
      'Upper Siang': {

        'Siang City': [
          const VillageRecord(
            villageName: 'Siang Rural',
            lgdCode: '500150',
            gramPanchayat: 'Siang GP',
            policeStationPostOffice: 'Siang PS / PO',
          ),
          const VillageRecord(
            villageName: 'Siang North',
            lgdCode: '500151',
            gramPanchayat: 'Siang Ward 1',
            policeStationPostOffice: 'Siang PS / PO',
          ),
        ],
        'Siang Block': [
          const VillageRecord(
            villageName: 'Siang East',
            lgdCode: '500152',
            gramPanchayat: 'Siang East GP',
            policeStationPostOffice: 'Siang Rural PS',
          ),
          const VillageRecord(
            villageName: 'Siang South',
            lgdCode: '500153',
            gramPanchayat: 'Siang South GP',
            policeStationPostOffice: 'Siang Rural PS',
          ),
        ],
      },
      'Upper Subansiri': {

        'Upper Subansiri City': [
          const VillageRecord(
            villageName: 'Upper Subansiri Rural',
            lgdCode: '500162',
            gramPanchayat: 'Upper Subansiri GP',
            policeStationPostOffice: 'Upper Subansiri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Upper Subansiri North',
            lgdCode: '500163',
            gramPanchayat: 'Upper Subansiri Ward 1',
            policeStationPostOffice: 'Upper Subansiri PS / PO',
          ),
        ],
        'Upper Subansiri Block': [
          const VillageRecord(
            villageName: 'Upper Subansiri East',
            lgdCode: '500164',
            gramPanchayat: 'Upper Subansiri East GP',
            policeStationPostOffice: 'Upper Subansiri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Upper Subansiri South',
            lgdCode: '500165',
            gramPanchayat: 'Upper Subansiri South GP',
            policeStationPostOffice: 'Upper Subansiri Rural PS',
          ),
        ],
      },
      'West Kameng': {

        'West Kameng City': [
          const VillageRecord(
            villageName: 'West Kameng Rural',
            lgdCode: '500166',
            gramPanchayat: 'West Kameng GP',
            policeStationPostOffice: 'West Kameng PS / PO',
          ),
          const VillageRecord(
            villageName: 'West Kameng North',
            lgdCode: '500167',
            gramPanchayat: 'West Kameng Ward 1',
            policeStationPostOffice: 'West Kameng PS / PO',
          ),
        ],
        'West Kameng Block': [
          const VillageRecord(
            villageName: 'West Kameng East',
            lgdCode: '500168',
            gramPanchayat: 'West Kameng East GP',
            policeStationPostOffice: 'West Kameng Rural PS',
          ),
          const VillageRecord(
            villageName: 'West Kameng South',
            lgdCode: '500169',
            gramPanchayat: 'West Kameng South GP',
            policeStationPostOffice: 'West Kameng Rural PS',
          ),
        ],
      },
      'West Siang': {

        'Siang City': [
          const VillageRecord(
            villageName: 'Siang Rural',
            lgdCode: '500150',
            gramPanchayat: 'Siang GP',
            policeStationPostOffice: 'Siang PS / PO',
          ),
          const VillageRecord(
            villageName: 'Siang North',
            lgdCode: '500151',
            gramPanchayat: 'Siang Ward 1',
            policeStationPostOffice: 'Siang PS / PO',
          ),
        ],
        'Siang Block': [
          const VillageRecord(
            villageName: 'Siang East',
            lgdCode: '500152',
            gramPanchayat: 'Siang East GP',
            policeStationPostOffice: 'Siang Rural PS',
          ),
          const VillageRecord(
            villageName: 'Siang South',
            lgdCode: '500153',
            gramPanchayat: 'Siang South GP',
            policeStationPostOffice: 'Siang Rural PS',
          ),
        ],
      },
      'Itanagar': {

        'Itanagar City': [
          const VillageRecord(
            villageName: 'Itanagar Rural',
            lgdCode: '500174',
            gramPanchayat: 'Itanagar GP',
            policeStationPostOffice: 'Itanagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Itanagar North',
            lgdCode: '500175',
            gramPanchayat: 'Itanagar Ward 1',
            policeStationPostOffice: 'Itanagar PS / PO',
          ),
        ],
        'Itanagar Block': [
          const VillageRecord(
            villageName: 'Itanagar East',
            lgdCode: '500176',
            gramPanchayat: 'Itanagar East GP',
            policeStationPostOffice: 'Itanagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Itanagar South',
            lgdCode: '500177',
            gramPanchayat: 'Itanagar South GP',
            policeStationPostOffice: 'Itanagar Rural PS',
          ),
        ],
      },
    },
    'Assam': {
      'Baksa': {

        'Baksa City': [
          const VillageRecord(
            villageName: 'Baksa Rural',
            lgdCode: '500178',
            gramPanchayat: 'Baksa GP',
            policeStationPostOffice: 'Baksa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Baksa North',
            lgdCode: '500179',
            gramPanchayat: 'Baksa Ward 1',
            policeStationPostOffice: 'Baksa PS / PO',
          ),
        ],
        'Baksa Block': [
          const VillageRecord(
            villageName: 'Baksa East',
            lgdCode: '500180',
            gramPanchayat: 'Baksa East GP',
            policeStationPostOffice: 'Baksa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Baksa South',
            lgdCode: '500181',
            gramPanchayat: 'Baksa South GP',
            policeStationPostOffice: 'Baksa Rural PS',
          ),
        ],
      },
      'Barpeta': {

        'Barpeta City': [
          const VillageRecord(
            villageName: 'Barpeta Rural',
            lgdCode: '500182',
            gramPanchayat: 'Barpeta GP',
            policeStationPostOffice: 'Barpeta PS / PO',
          ),
          const VillageRecord(
            villageName: 'Barpeta North',
            lgdCode: '500183',
            gramPanchayat: 'Barpeta Ward 1',
            policeStationPostOffice: 'Barpeta PS / PO',
          ),
        ],
        'Barpeta Block': [
          const VillageRecord(
            villageName: 'Barpeta East',
            lgdCode: '500184',
            gramPanchayat: 'Barpeta East GP',
            policeStationPostOffice: 'Barpeta Rural PS',
          ),
          const VillageRecord(
            villageName: 'Barpeta South',
            lgdCode: '500185',
            gramPanchayat: 'Barpeta South GP',
            policeStationPostOffice: 'Barpeta Rural PS',
          ),
        ],
      },
      'Biswanath': {

        'Biswanath City': [
          const VillageRecord(
            villageName: 'Biswanath Rural',
            lgdCode: '500186',
            gramPanchayat: 'Biswanath GP',
            policeStationPostOffice: 'Biswanath PS / PO',
          ),
          const VillageRecord(
            villageName: 'Biswanath North',
            lgdCode: '500187',
            gramPanchayat: 'Biswanath Ward 1',
            policeStationPostOffice: 'Biswanath PS / PO',
          ),
        ],
        'Biswanath Block': [
          const VillageRecord(
            villageName: 'Biswanath East',
            lgdCode: '500188',
            gramPanchayat: 'Biswanath East GP',
            policeStationPostOffice: 'Biswanath Rural PS',
          ),
          const VillageRecord(
            villageName: 'Biswanath South',
            lgdCode: '500189',
            gramPanchayat: 'Biswanath South GP',
            policeStationPostOffice: 'Biswanath Rural PS',
          ),
        ],
      },
      'Bongaigaon': {

        'Bongaigaon City': [
          const VillageRecord(
            villageName: 'Bongaigaon Rural',
            lgdCode: '500190',
            gramPanchayat: 'Bongaigaon GP',
            policeStationPostOffice: 'Bongaigaon PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bongaigaon North',
            lgdCode: '500191',
            gramPanchayat: 'Bongaigaon Ward 1',
            policeStationPostOffice: 'Bongaigaon PS / PO',
          ),
        ],
        'Bongaigaon Block': [
          const VillageRecord(
            villageName: 'Bongaigaon East',
            lgdCode: '500192',
            gramPanchayat: 'Bongaigaon East GP',
            policeStationPostOffice: 'Bongaigaon Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bongaigaon South',
            lgdCode: '500193',
            gramPanchayat: 'Bongaigaon South GP',
            policeStationPostOffice: 'Bongaigaon Rural PS',
          ),
        ],
      },
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
      'Charaideo': {

        'Charaideo City': [
          const VillageRecord(
            villageName: 'Charaideo Rural',
            lgdCode: '500194',
            gramPanchayat: 'Charaideo GP',
            policeStationPostOffice: 'Charaideo PS / PO',
          ),
          const VillageRecord(
            villageName: 'Charaideo North',
            lgdCode: '500195',
            gramPanchayat: 'Charaideo Ward 1',
            policeStationPostOffice: 'Charaideo PS / PO',
          ),
        ],
        'Charaideo Block': [
          const VillageRecord(
            villageName: 'Charaideo East',
            lgdCode: '500196',
            gramPanchayat: 'Charaideo East GP',
            policeStationPostOffice: 'Charaideo Rural PS',
          ),
          const VillageRecord(
            villageName: 'Charaideo South',
            lgdCode: '500197',
            gramPanchayat: 'Charaideo South GP',
            policeStationPostOffice: 'Charaideo Rural PS',
          ),
        ],
      },
      'Chirang': {

        'Chirang City': [
          const VillageRecord(
            villageName: 'Chirang Rural',
            lgdCode: '500198',
            gramPanchayat: 'Chirang GP',
            policeStationPostOffice: 'Chirang PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chirang North',
            lgdCode: '500199',
            gramPanchayat: 'Chirang Ward 1',
            policeStationPostOffice: 'Chirang PS / PO',
          ),
        ],
        'Chirang Block': [
          const VillageRecord(
            villageName: 'Chirang East',
            lgdCode: '500200',
            gramPanchayat: 'Chirang East GP',
            policeStationPostOffice: 'Chirang Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chirang South',
            lgdCode: '500201',
            gramPanchayat: 'Chirang South GP',
            policeStationPostOffice: 'Chirang Rural PS',
          ),
        ],
      },
      'Darrang': {

        'Darrang City': [
          const VillageRecord(
            villageName: 'Darrang Rural',
            lgdCode: '500202',
            gramPanchayat: 'Darrang GP',
            policeStationPostOffice: 'Darrang PS / PO',
          ),
          const VillageRecord(
            villageName: 'Darrang North',
            lgdCode: '500203',
            gramPanchayat: 'Darrang Ward 1',
            policeStationPostOffice: 'Darrang PS / PO',
          ),
        ],
        'Darrang Block': [
          const VillageRecord(
            villageName: 'Darrang East',
            lgdCode: '500204',
            gramPanchayat: 'Darrang East GP',
            policeStationPostOffice: 'Darrang Rural PS',
          ),
          const VillageRecord(
            villageName: 'Darrang South',
            lgdCode: '500205',
            gramPanchayat: 'Darrang South GP',
            policeStationPostOffice: 'Darrang Rural PS',
          ),
        ],
      },
      'Dhemaji': {

        'Dhemaji City': [
          const VillageRecord(
            villageName: 'Dhemaji Rural',
            lgdCode: '500206',
            gramPanchayat: 'Dhemaji GP',
            policeStationPostOffice: 'Dhemaji PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dhemaji North',
            lgdCode: '500207',
            gramPanchayat: 'Dhemaji Ward 1',
            policeStationPostOffice: 'Dhemaji PS / PO',
          ),
        ],
        'Dhemaji Block': [
          const VillageRecord(
            villageName: 'Dhemaji East',
            lgdCode: '500208',
            gramPanchayat: 'Dhemaji East GP',
            policeStationPostOffice: 'Dhemaji Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dhemaji South',
            lgdCode: '500209',
            gramPanchayat: 'Dhemaji South GP',
            policeStationPostOffice: 'Dhemaji Rural PS',
          ),
        ],
      },
      'Dhubri': {

        'Dhubri City': [
          const VillageRecord(
            villageName: 'Dhubri Rural',
            lgdCode: '500210',
            gramPanchayat: 'Dhubri GP',
            policeStationPostOffice: 'Dhubri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dhubri North',
            lgdCode: '500211',
            gramPanchayat: 'Dhubri Ward 1',
            policeStationPostOffice: 'Dhubri PS / PO',
          ),
        ],
        'Dhubri Block': [
          const VillageRecord(
            villageName: 'Dhubri East',
            lgdCode: '500212',
            gramPanchayat: 'Dhubri East GP',
            policeStationPostOffice: 'Dhubri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dhubri South',
            lgdCode: '500213',
            gramPanchayat: 'Dhubri South GP',
            policeStationPostOffice: 'Dhubri Rural PS',
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
      'Dima Hasao': {

        'Dima Hasao City': [
          const VillageRecord(
            villageName: 'Dima Hasao Rural',
            lgdCode: '500266',
            gramPanchayat: 'Dima Hasao GP',
            policeStationPostOffice: 'Dima Hasao PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dima Hasao North',
            lgdCode: '500267',
            gramPanchayat: 'Dima Hasao Ward 1',
            policeStationPostOffice: 'Dima Hasao PS / PO',
          ),
        ],
        'Dima Hasao Block': [
          const VillageRecord(
            villageName: 'Dima Hasao East',
            lgdCode: '500268',
            gramPanchayat: 'Dima Hasao East GP',
            policeStationPostOffice: 'Dima Hasao Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dima Hasao South',
            lgdCode: '500269',
            gramPanchayat: 'Dima Hasao South GP',
            policeStationPostOffice: 'Dima Hasao Rural PS',
          ),
        ],
      },
      'Goalpara': {

        'Goalpara City': [
          const VillageRecord(
            villageName: 'Goalpara Rural',
            lgdCode: '500218',
            gramPanchayat: 'Goalpara GP',
            policeStationPostOffice: 'Goalpara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Goalpara North',
            lgdCode: '500219',
            gramPanchayat: 'Goalpara Ward 1',
            policeStationPostOffice: 'Goalpara PS / PO',
          ),
        ],
        'Goalpara Block': [
          const VillageRecord(
            villageName: 'Goalpara East',
            lgdCode: '500220',
            gramPanchayat: 'Goalpara East GP',
            policeStationPostOffice: 'Goalpara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Goalpara South',
            lgdCode: '500221',
            gramPanchayat: 'Goalpara South GP',
            policeStationPostOffice: 'Goalpara Rural PS',
          ),
        ],
      },
      'Golaghat': {

        'Golaghat City': [
          const VillageRecord(
            villageName: 'Golaghat Rural',
            lgdCode: '500222',
            gramPanchayat: 'Golaghat GP',
            policeStationPostOffice: 'Golaghat PS / PO',
          ),
          const VillageRecord(
            villageName: 'Golaghat North',
            lgdCode: '500223',
            gramPanchayat: 'Golaghat Ward 1',
            policeStationPostOffice: 'Golaghat PS / PO',
          ),
        ],
        'Golaghat Block': [
          const VillageRecord(
            villageName: 'Golaghat East',
            lgdCode: '500224',
            gramPanchayat: 'Golaghat East GP',
            policeStationPostOffice: 'Golaghat Rural PS',
          ),
          const VillageRecord(
            villageName: 'Golaghat South',
            lgdCode: '500225',
            gramPanchayat: 'Golaghat South GP',
            policeStationPostOffice: 'Golaghat Rural PS',
          ),
        ],
      },
      'Hailakandi': {

        'Hailakandi City': [
          const VillageRecord(
            villageName: 'Hailakandi Rural',
            lgdCode: '500226',
            gramPanchayat: 'Hailakandi GP',
            policeStationPostOffice: 'Hailakandi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hailakandi North',
            lgdCode: '500227',
            gramPanchayat: 'Hailakandi Ward 1',
            policeStationPostOffice: 'Hailakandi PS / PO',
          ),
        ],
        'Hailakandi Block': [
          const VillageRecord(
            villageName: 'Hailakandi East',
            lgdCode: '500228',
            gramPanchayat: 'Hailakandi East GP',
            policeStationPostOffice: 'Hailakandi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hailakandi South',
            lgdCode: '500229',
            gramPanchayat: 'Hailakandi South GP',
            policeStationPostOffice: 'Hailakandi Rural PS',
          ),
        ],
      },
      'Hojai': {

        'Hojai City': [
          const VillageRecord(
            villageName: 'Hojai Rural',
            lgdCode: '500230',
            gramPanchayat: 'Hojai GP',
            policeStationPostOffice: 'Hojai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hojai North',
            lgdCode: '500231',
            gramPanchayat: 'Hojai Ward 1',
            policeStationPostOffice: 'Hojai PS / PO',
          ),
        ],
        'Hojai Block': [
          const VillageRecord(
            villageName: 'Hojai East',
            lgdCode: '500232',
            gramPanchayat: 'Hojai East GP',
            policeStationPostOffice: 'Hojai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hojai South',
            lgdCode: '500233',
            gramPanchayat: 'Hojai South GP',
            policeStationPostOffice: 'Hojai Rural PS',
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
      'Kamrup': {


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
      'Karbi Anglong': {

        'Karbi Anglong City': [
          const VillageRecord(
            villageName: 'Karbi Anglong Rural',
            lgdCode: '500234',
            gramPanchayat: 'Karbi Anglong GP',
            policeStationPostOffice: 'Karbi Anglong PS / PO',
          ),
          const VillageRecord(
            villageName: 'Karbi Anglong North',
            lgdCode: '500235',
            gramPanchayat: 'Karbi Anglong Ward 1',
            policeStationPostOffice: 'Karbi Anglong PS / PO',
          ),
        ],
        'Karbi Anglong Block': [
          const VillageRecord(
            villageName: 'Karbi Anglong East',
            lgdCode: '500236',
            gramPanchayat: 'Karbi Anglong East GP',
            policeStationPostOffice: 'Karbi Anglong Rural PS',
          ),
          const VillageRecord(
            villageName: 'Karbi Anglong South',
            lgdCode: '500237',
            gramPanchayat: 'Karbi Anglong South GP',
            policeStationPostOffice: 'Karbi Anglong Rural PS',
          ),
        ],
      },
      'Karimganj': {

        'Karimganj City': [
          const VillageRecord(
            villageName: 'Karimganj Rural',
            lgdCode: '500238',
            gramPanchayat: 'Karimganj GP',
            policeStationPostOffice: 'Karimganj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Karimganj North',
            lgdCode: '500239',
            gramPanchayat: 'Karimganj Ward 1',
            policeStationPostOffice: 'Karimganj PS / PO',
          ),
        ],
        'Karimganj Block': [
          const VillageRecord(
            villageName: 'Karimganj East',
            lgdCode: '500240',
            gramPanchayat: 'Karimganj East GP',
            policeStationPostOffice: 'Karimganj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Karimganj South',
            lgdCode: '500241',
            gramPanchayat: 'Karimganj South GP',
            policeStationPostOffice: 'Karimganj Rural PS',
          ),
        ],
      },
      'Kokrajhar': {

        'Kokrajhar City': [
          const VillageRecord(
            villageName: 'Kokrajhar Rural',
            lgdCode: '500242',
            gramPanchayat: 'Kokrajhar GP',
            policeStationPostOffice: 'Kokrajhar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kokrajhar North',
            lgdCode: '500243',
            gramPanchayat: 'Kokrajhar Ward 1',
            policeStationPostOffice: 'Kokrajhar PS / PO',
          ),
        ],
        'Kokrajhar Block': [
          const VillageRecord(
            villageName: 'Kokrajhar East',
            lgdCode: '500244',
            gramPanchayat: 'Kokrajhar East GP',
            policeStationPostOffice: 'Kokrajhar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kokrajhar South',
            lgdCode: '500245',
            gramPanchayat: 'Kokrajhar South GP',
            policeStationPostOffice: 'Kokrajhar Rural PS',
          ),
        ],
      },
      'Lakhimpur': {

        'Lakhimpur City': [
          const VillageRecord(
            villageName: 'Lakhimpur Rural',
            lgdCode: '500246',
            gramPanchayat: 'Lakhimpur GP',
            policeStationPostOffice: 'Lakhimpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lakhimpur North',
            lgdCode: '500247',
            gramPanchayat: 'Lakhimpur Ward 1',
            policeStationPostOffice: 'Lakhimpur PS / PO',
          ),
        ],
        'Lakhimpur Block': [
          const VillageRecord(
            villageName: 'Lakhimpur East',
            lgdCode: '500248',
            gramPanchayat: 'Lakhimpur East GP',
            policeStationPostOffice: 'Lakhimpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lakhimpur South',
            lgdCode: '500249',
            gramPanchayat: 'Lakhimpur South GP',
            policeStationPostOffice: 'Lakhimpur Rural PS',
          ),
        ],
      },
      'Majuli': {

        'Majuli City': [
          const VillageRecord(
            villageName: 'Majuli Rural',
            lgdCode: '500250',
            gramPanchayat: 'Majuli GP',
            policeStationPostOffice: 'Majuli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Majuli North',
            lgdCode: '500251',
            gramPanchayat: 'Majuli Ward 1',
            policeStationPostOffice: 'Majuli PS / PO',
          ),
        ],
        'Majuli Block': [
          const VillageRecord(
            villageName: 'Majuli East',
            lgdCode: '500252',
            gramPanchayat: 'Majuli East GP',
            policeStationPostOffice: 'Majuli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Majuli South',
            lgdCode: '500253',
            gramPanchayat: 'Majuli South GP',
            policeStationPostOffice: 'Majuli Rural PS',
          ),
        ],
      },
      'Morigaon': {

        'Morigaon City': [
          const VillageRecord(
            villageName: 'Morigaon Rural',
            lgdCode: '500254',
            gramPanchayat: 'Morigaon GP',
            policeStationPostOffice: 'Morigaon PS / PO',
          ),
          const VillageRecord(
            villageName: 'Morigaon North',
            lgdCode: '500255',
            gramPanchayat: 'Morigaon Ward 1',
            policeStationPostOffice: 'Morigaon PS / PO',
          ),
        ],
        'Morigaon Block': [
          const VillageRecord(
            villageName: 'Morigaon East',
            lgdCode: '500256',
            gramPanchayat: 'Morigaon East GP',
            policeStationPostOffice: 'Morigaon Rural PS',
          ),
          const VillageRecord(
            villageName: 'Morigaon South',
            lgdCode: '500257',
            gramPanchayat: 'Morigaon South GP',
            policeStationPostOffice: 'Morigaon Rural PS',
          ),
        ],
      },
      'Nagaon': {

        'Nagaon City': [
          const VillageRecord(
            villageName: 'Nagaon Rural',
            lgdCode: '500258',
            gramPanchayat: 'Nagaon GP',
            policeStationPostOffice: 'Nagaon PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nagaon North',
            lgdCode: '500259',
            gramPanchayat: 'Nagaon Ward 1',
            policeStationPostOffice: 'Nagaon PS / PO',
          ),
        ],
        'Nagaon Block': [
          const VillageRecord(
            villageName: 'Nagaon East',
            lgdCode: '500260',
            gramPanchayat: 'Nagaon East GP',
            policeStationPostOffice: 'Nagaon Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nagaon South',
            lgdCode: '500261',
            gramPanchayat: 'Nagaon South GP',
            policeStationPostOffice: 'Nagaon Rural PS',
          ),
        ],
      },
      'Nalbari': {

        'Nalbari City': [
          const VillageRecord(
            villageName: 'Nalbari Rural',
            lgdCode: '500262',
            gramPanchayat: 'Nalbari GP',
            policeStationPostOffice: 'Nalbari PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nalbari North',
            lgdCode: '500263',
            gramPanchayat: 'Nalbari Ward 1',
            policeStationPostOffice: 'Nalbari PS / PO',
          ),
        ],
        'Nalbari Block': [
          const VillageRecord(
            villageName: 'Nalbari East',
            lgdCode: '500264',
            gramPanchayat: 'Nalbari East GP',
            policeStationPostOffice: 'Nalbari Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nalbari South',
            lgdCode: '500265',
            gramPanchayat: 'Nalbari South GP',
            policeStationPostOffice: 'Nalbari Rural PS',
          ),
        ],
      },
      'Dima Hasao': {

        'Dima Hasao City': [
          const VillageRecord(
            villageName: 'Dima Hasao Rural',
            lgdCode: '500266',
            gramPanchayat: 'Dima Hasao GP',
            policeStationPostOffice: 'Dima Hasao PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dima Hasao North',
            lgdCode: '500267',
            gramPanchayat: 'Dima Hasao Ward 1',
            policeStationPostOffice: 'Dima Hasao PS / PO',
          ),
        ],
        'Dima Hasao Block': [
          const VillageRecord(
            villageName: 'Dima Hasao East',
            lgdCode: '500268',
            gramPanchayat: 'Dima Hasao East GP',
            policeStationPostOffice: 'Dima Hasao Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dima Hasao South',
            lgdCode: '500269',
            gramPanchayat: 'Dima Hasao South GP',
            policeStationPostOffice: 'Dima Hasao Rural PS',
          ),
        ],
      },
      'Sivasagar': {

        'Sivasagar City': [
          const VillageRecord(
            villageName: 'Sivasagar Rural',
            lgdCode: '500270',
            gramPanchayat: 'Sivasagar GP',
            policeStationPostOffice: 'Sivasagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sivasagar North',
            lgdCode: '500271',
            gramPanchayat: 'Sivasagar Ward 1',
            policeStationPostOffice: 'Sivasagar PS / PO',
          ),
        ],
        'Sivasagar Block': [
          const VillageRecord(
            villageName: 'Sivasagar East',
            lgdCode: '500272',
            gramPanchayat: 'Sivasagar East GP',
            policeStationPostOffice: 'Sivasagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sivasagar South',
            lgdCode: '500273',
            gramPanchayat: 'Sivasagar South GP',
            policeStationPostOffice: 'Sivasagar Rural PS',
          ),
        ],
      },
      'Sonitpur': {

        'Sonitpur City': [
          const VillageRecord(
            villageName: 'Sonitpur Rural',
            lgdCode: '500274',
            gramPanchayat: 'Sonitpur GP',
            policeStationPostOffice: 'Sonitpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sonitpur North',
            lgdCode: '500275',
            gramPanchayat: 'Sonitpur Ward 1',
            policeStationPostOffice: 'Sonitpur PS / PO',
          ),
        ],
        'Sonitpur Block': [
          const VillageRecord(
            villageName: 'Sonitpur East',
            lgdCode: '500276',
            gramPanchayat: 'Sonitpur East GP',
            policeStationPostOffice: 'Sonitpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sonitpur South',
            lgdCode: '500277',
            gramPanchayat: 'Sonitpur South GP',
            policeStationPostOffice: 'Sonitpur Rural PS',
          ),
        ],
      },
      'South Salmara-Mankachar': {

        'South Salmara-Mankachar City': [
          const VillageRecord(
            villageName: 'South Salmara-Mankachar Rural',
            lgdCode: '500278',
            gramPanchayat: 'South Salmara-Mankachar GP',
            policeStationPostOffice: 'South Salmara-Mankachar PS / PO',
          ),
          const VillageRecord(
            villageName: 'South Salmara-Mankachar North',
            lgdCode: '500279',
            gramPanchayat: 'South Salmara-Mankachar Ward 1',
            policeStationPostOffice: 'South Salmara-Mankachar PS / PO',
          ),
        ],
        'South Salmara-Mankachar Block': [
          const VillageRecord(
            villageName: 'South Salmara-Mankachar East',
            lgdCode: '500280',
            gramPanchayat: 'South Salmara-Mankachar East GP',
            policeStationPostOffice: 'South Salmara-Mankachar Rural PS',
          ),
          const VillageRecord(
            villageName: 'South Salmara-Mankachar South',
            lgdCode: '500281',
            gramPanchayat: 'South Salmara-Mankachar South GP',
            policeStationPostOffice: 'South Salmara-Mankachar Rural PS',
          ),
        ],
      },
      'Tinsukia': {

        'Tinsukia City': [
          const VillageRecord(
            villageName: 'Tinsukia Rural',
            lgdCode: '500282',
            gramPanchayat: 'Tinsukia GP',
            policeStationPostOffice: 'Tinsukia PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tinsukia North',
            lgdCode: '500283',
            gramPanchayat: 'Tinsukia Ward 1',
            policeStationPostOffice: 'Tinsukia PS / PO',
          ),
        ],
        'Tinsukia Block': [
          const VillageRecord(
            villageName: 'Tinsukia East',
            lgdCode: '500284',
            gramPanchayat: 'Tinsukia East GP',
            policeStationPostOffice: 'Tinsukia Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tinsukia South',
            lgdCode: '500285',
            gramPanchayat: 'Tinsukia South GP',
            policeStationPostOffice: 'Tinsukia Rural PS',
          ),
        ],
      },
      'Udalguri': {

        'Udalguri City': [
          const VillageRecord(
            villageName: 'Udalguri Rural',
            lgdCode: '500286',
            gramPanchayat: 'Udalguri GP',
            policeStationPostOffice: 'Udalguri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Udalguri North',
            lgdCode: '500287',
            gramPanchayat: 'Udalguri Ward 1',
            policeStationPostOffice: 'Udalguri PS / PO',
          ),
        ],
        'Udalguri Block': [
          const VillageRecord(
            villageName: 'Udalguri East',
            lgdCode: '500288',
            gramPanchayat: 'Udalguri East GP',
            policeStationPostOffice: 'Udalguri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Udalguri South',
            lgdCode: '500289',
            gramPanchayat: 'Udalguri South GP',
            policeStationPostOffice: 'Udalguri Rural PS',
          ),
        ],
      },
      'West Karbi Anglong': {

        'Karbi Anglong City': [
          const VillageRecord(
            villageName: 'Karbi Anglong Rural',
            lgdCode: '500234',
            gramPanchayat: 'Karbi Anglong GP',
            policeStationPostOffice: 'Karbi Anglong PS / PO',
          ),
          const VillageRecord(
            villageName: 'Karbi Anglong North',
            lgdCode: '500235',
            gramPanchayat: 'Karbi Anglong Ward 1',
            policeStationPostOffice: 'Karbi Anglong PS / PO',
          ),
        ],
        'Karbi Anglong Block': [
          const VillageRecord(
            villageName: 'Karbi Anglong East',
            lgdCode: '500236',
            gramPanchayat: 'Karbi Anglong East GP',
            policeStationPostOffice: 'Karbi Anglong Rural PS',
          ),
          const VillageRecord(
            villageName: 'Karbi Anglong South',
            lgdCode: '500237',
            gramPanchayat: 'Karbi Anglong South GP',
            policeStationPostOffice: 'Karbi Anglong Rural PS',
          ),
        ],
      },
      'Bajali': {

        'Bajali City': [
          const VillageRecord(
            villageName: 'Bajali Rural',
            lgdCode: '500294',
            gramPanchayat: 'Bajali GP',
            policeStationPostOffice: 'Bajali PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bajali North',
            lgdCode: '500295',
            gramPanchayat: 'Bajali Ward 1',
            policeStationPostOffice: 'Bajali PS / PO',
          ),
        ],
        'Bajali Block': [
          const VillageRecord(
            villageName: 'Bajali East',
            lgdCode: '500296',
            gramPanchayat: 'Bajali East GP',
            policeStationPostOffice: 'Bajali Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bajali South',
            lgdCode: '500297',
            gramPanchayat: 'Bajali South GP',
            policeStationPostOffice: 'Bajali Rural PS',
          ),
        ],
      },
      'Tamulpur': {

        'Tamulpur City': [
          const VillageRecord(
            villageName: 'Tamulpur Rural',
            lgdCode: '500298',
            gramPanchayat: 'Tamulpur GP',
            policeStationPostOffice: 'Tamulpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tamulpur North',
            lgdCode: '500299',
            gramPanchayat: 'Tamulpur Ward 1',
            policeStationPostOffice: 'Tamulpur PS / PO',
          ),
        ],
        'Tamulpur Block': [
          const VillageRecord(
            villageName: 'Tamulpur East',
            lgdCode: '500300',
            gramPanchayat: 'Tamulpur East GP',
            policeStationPostOffice: 'Tamulpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tamulpur South',
            lgdCode: '500301',
            gramPanchayat: 'Tamulpur South GP',
            policeStationPostOffice: 'Tamulpur Rural PS',
          ),
        ],
      },
    },
    'Bihar': {
      'Araria': {

        'Araria City': [
          const VillageRecord(
            villageName: 'Araria Rural',
            lgdCode: '500302',
            gramPanchayat: 'Araria GP',
            policeStationPostOffice: 'Araria PS / PO',
          ),
          const VillageRecord(
            villageName: 'Araria North',
            lgdCode: '500303',
            gramPanchayat: 'Araria Ward 1',
            policeStationPostOffice: 'Araria PS / PO',
          ),
        ],
        'Araria Block': [
          const VillageRecord(
            villageName: 'Araria East',
            lgdCode: '500304',
            gramPanchayat: 'Araria East GP',
            policeStationPostOffice: 'Araria Rural PS',
          ),
          const VillageRecord(
            villageName: 'Araria South',
            lgdCode: '500305',
            gramPanchayat: 'Araria South GP',
            policeStationPostOffice: 'Araria Rural PS',
          ),
        ],
      },
      'Arwal': {

        'Arwal City': [
          const VillageRecord(
            villageName: 'Arwal Rural',
            lgdCode: '500306',
            gramPanchayat: 'Arwal GP',
            policeStationPostOffice: 'Arwal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Arwal North',
            lgdCode: '500307',
            gramPanchayat: 'Arwal Ward 1',
            policeStationPostOffice: 'Arwal PS / PO',
          ),
        ],
        'Arwal Block': [
          const VillageRecord(
            villageName: 'Arwal East',
            lgdCode: '500308',
            gramPanchayat: 'Arwal East GP',
            policeStationPostOffice: 'Arwal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Arwal South',
            lgdCode: '500309',
            gramPanchayat: 'Arwal South GP',
            policeStationPostOffice: 'Arwal Rural PS',
          ),
        ],
      },
      'Aurangabad': {

        'Aurangabad City': [
          const VillageRecord(
            villageName: 'Aurangabad Rural',
            lgdCode: '500310',
            gramPanchayat: 'Aurangabad GP',
            policeStationPostOffice: 'Aurangabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Aurangabad North',
            lgdCode: '500311',
            gramPanchayat: 'Aurangabad Ward 1',
            policeStationPostOffice: 'Aurangabad PS / PO',
          ),
        ],
        'Aurangabad Block': [
          const VillageRecord(
            villageName: 'Aurangabad East',
            lgdCode: '500312',
            gramPanchayat: 'Aurangabad East GP',
            policeStationPostOffice: 'Aurangabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Aurangabad South',
            lgdCode: '500313',
            gramPanchayat: 'Aurangabad South GP',
            policeStationPostOffice: 'Aurangabad Rural PS',
          ),
        ],
      },
      'Banka': {

        'Banka City': [
          const VillageRecord(
            villageName: 'Banka Rural',
            lgdCode: '500314',
            gramPanchayat: 'Banka GP',
            policeStationPostOffice: 'Banka PS / PO',
          ),
          const VillageRecord(
            villageName: 'Banka North',
            lgdCode: '500315',
            gramPanchayat: 'Banka Ward 1',
            policeStationPostOffice: 'Banka PS / PO',
          ),
        ],
        'Banka Block': [
          const VillageRecord(
            villageName: 'Banka East',
            lgdCode: '500316',
            gramPanchayat: 'Banka East GP',
            policeStationPostOffice: 'Banka Rural PS',
          ),
          const VillageRecord(
            villageName: 'Banka South',
            lgdCode: '500317',
            gramPanchayat: 'Banka South GP',
            policeStationPostOffice: 'Banka Rural PS',
          ),
        ],
      },
      'Begusarai': {

        'Begusarai City': [
          const VillageRecord(
            villageName: 'Begusarai Rural',
            lgdCode: '500318',
            gramPanchayat: 'Begusarai GP',
            policeStationPostOffice: 'Begusarai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Begusarai North',
            lgdCode: '500319',
            gramPanchayat: 'Begusarai Ward 1',
            policeStationPostOffice: 'Begusarai PS / PO',
          ),
        ],
        'Begusarai Block': [
          const VillageRecord(
            villageName: 'Begusarai East',
            lgdCode: '500320',
            gramPanchayat: 'Begusarai East GP',
            policeStationPostOffice: 'Begusarai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Begusarai South',
            lgdCode: '500321',
            gramPanchayat: 'Begusarai South GP',
            policeStationPostOffice: 'Begusarai Rural PS',
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
      'Bhojpur': {

        'Bhojpur City': [
          const VillageRecord(
            villageName: 'Bhojpur Rural',
            lgdCode: '500322',
            gramPanchayat: 'Bhojpur GP',
            policeStationPostOffice: 'Bhojpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhojpur North',
            lgdCode: '500323',
            gramPanchayat: 'Bhojpur Ward 1',
            policeStationPostOffice: 'Bhojpur PS / PO',
          ),
        ],
        'Bhojpur Block': [
          const VillageRecord(
            villageName: 'Bhojpur East',
            lgdCode: '500324',
            gramPanchayat: 'Bhojpur East GP',
            policeStationPostOffice: 'Bhojpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhojpur South',
            lgdCode: '500325',
            gramPanchayat: 'Bhojpur South GP',
            policeStationPostOffice: 'Bhojpur Rural PS',
          ),
        ],
      },
      'Buxar': {

        'Buxar City': [
          const VillageRecord(
            villageName: 'Buxar Rural',
            lgdCode: '500326',
            gramPanchayat: 'Buxar GP',
            policeStationPostOffice: 'Buxar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Buxar North',
            lgdCode: '500327',
            gramPanchayat: 'Buxar Ward 1',
            policeStationPostOffice: 'Buxar PS / PO',
          ),
        ],
        'Buxar Block': [
          const VillageRecord(
            villageName: 'Buxar East',
            lgdCode: '500328',
            gramPanchayat: 'Buxar East GP',
            policeStationPostOffice: 'Buxar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Buxar South',
            lgdCode: '500329',
            gramPanchayat: 'Buxar South GP',
            policeStationPostOffice: 'Buxar Rural PS',
          ),
        ],
      },
      'Darbhanga': {

        'Darbhanga City': [
          const VillageRecord(
            villageName: 'Darbhanga Rural',
            lgdCode: '500330',
            gramPanchayat: 'Darbhanga GP',
            policeStationPostOffice: 'Darbhanga PS / PO',
          ),
          const VillageRecord(
            villageName: 'Darbhanga North',
            lgdCode: '500331',
            gramPanchayat: 'Darbhanga Ward 1',
            policeStationPostOffice: 'Darbhanga PS / PO',
          ),
        ],
        'Darbhanga Block': [
          const VillageRecord(
            villageName: 'Darbhanga East',
            lgdCode: '500332',
            gramPanchayat: 'Darbhanga East GP',
            policeStationPostOffice: 'Darbhanga Rural PS',
          ),
          const VillageRecord(
            villageName: 'Darbhanga South',
            lgdCode: '500333',
            gramPanchayat: 'Darbhanga South GP',
            policeStationPostOffice: 'Darbhanga Rural PS',
          ),
        ],
      },
      'East Champaran': {

        'East Champaran City': [
          const VillageRecord(
            villageName: 'East Champaran Rural',
            lgdCode: '500334',
            gramPanchayat: 'East Champaran GP',
            policeStationPostOffice: 'East Champaran PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Champaran North',
            lgdCode: '500335',
            gramPanchayat: 'East Champaran Ward 1',
            policeStationPostOffice: 'East Champaran PS / PO',
          ),
        ],
        'East Champaran Block': [
          const VillageRecord(
            villageName: 'East Champaran East',
            lgdCode: '500336',
            gramPanchayat: 'East Champaran East GP',
            policeStationPostOffice: 'East Champaran Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Champaran South',
            lgdCode: '500337',
            gramPanchayat: 'East Champaran South GP',
            policeStationPostOffice: 'East Champaran Rural PS',
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
      'Gopalganj': {

        'Gopalganj City': [
          const VillageRecord(
            villageName: 'Gopalganj Rural',
            lgdCode: '500338',
            gramPanchayat: 'Gopalganj GP',
            policeStationPostOffice: 'Gopalganj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gopalganj North',
            lgdCode: '500339',
            gramPanchayat: 'Gopalganj Ward 1',
            policeStationPostOffice: 'Gopalganj PS / PO',
          ),
        ],
        'Gopalganj Block': [
          const VillageRecord(
            villageName: 'Gopalganj East',
            lgdCode: '500340',
            gramPanchayat: 'Gopalganj East GP',
            policeStationPostOffice: 'Gopalganj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gopalganj South',
            lgdCode: '500341',
            gramPanchayat: 'Gopalganj South GP',
            policeStationPostOffice: 'Gopalganj Rural PS',
          ),
        ],
      },
      'Jamui': {

        'Jamui City': [
          const VillageRecord(
            villageName: 'Jamui Rural',
            lgdCode: '500342',
            gramPanchayat: 'Jamui GP',
            policeStationPostOffice: 'Jamui PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jamui North',
            lgdCode: '500343',
            gramPanchayat: 'Jamui Ward 1',
            policeStationPostOffice: 'Jamui PS / PO',
          ),
        ],
        'Jamui Block': [
          const VillageRecord(
            villageName: 'Jamui East',
            lgdCode: '500344',
            gramPanchayat: 'Jamui East GP',
            policeStationPostOffice: 'Jamui Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jamui South',
            lgdCode: '500345',
            gramPanchayat: 'Jamui South GP',
            policeStationPostOffice: 'Jamui Rural PS',
          ),
        ],
      },
      'Jehanabad': {

        'Jehanabad City': [
          const VillageRecord(
            villageName: 'Jehanabad Rural',
            lgdCode: '500346',
            gramPanchayat: 'Jehanabad GP',
            policeStationPostOffice: 'Jehanabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jehanabad North',
            lgdCode: '500347',
            gramPanchayat: 'Jehanabad Ward 1',
            policeStationPostOffice: 'Jehanabad PS / PO',
          ),
        ],
        'Jehanabad Block': [
          const VillageRecord(
            villageName: 'Jehanabad East',
            lgdCode: '500348',
            gramPanchayat: 'Jehanabad East GP',
            policeStationPostOffice: 'Jehanabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jehanabad South',
            lgdCode: '500349',
            gramPanchayat: 'Jehanabad South GP',
            policeStationPostOffice: 'Jehanabad Rural PS',
          ),
        ],
      },
      'Kaimur': {

        'Kaimur City': [
          const VillageRecord(
            villageName: 'Kaimur Rural',
            lgdCode: '500350',
            gramPanchayat: 'Kaimur GP',
            policeStationPostOffice: 'Kaimur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kaimur North',
            lgdCode: '500351',
            gramPanchayat: 'Kaimur Ward 1',
            policeStationPostOffice: 'Kaimur PS / PO',
          ),
        ],
        'Kaimur Block': [
          const VillageRecord(
            villageName: 'Kaimur East',
            lgdCode: '500352',
            gramPanchayat: 'Kaimur East GP',
            policeStationPostOffice: 'Kaimur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kaimur South',
            lgdCode: '500353',
            gramPanchayat: 'Kaimur South GP',
            policeStationPostOffice: 'Kaimur Rural PS',
          ),
        ],
      },
      'Katihar': {

        'Katihar City': [
          const VillageRecord(
            villageName: 'Katihar Rural',
            lgdCode: '500354',
            gramPanchayat: 'Katihar GP',
            policeStationPostOffice: 'Katihar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Katihar North',
            lgdCode: '500355',
            gramPanchayat: 'Katihar Ward 1',
            policeStationPostOffice: 'Katihar PS / PO',
          ),
        ],
        'Katihar Block': [
          const VillageRecord(
            villageName: 'Katihar East',
            lgdCode: '500356',
            gramPanchayat: 'Katihar East GP',
            policeStationPostOffice: 'Katihar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Katihar South',
            lgdCode: '500357',
            gramPanchayat: 'Katihar South GP',
            policeStationPostOffice: 'Katihar Rural PS',
          ),
        ],
      },
      'Khagaria': {

        'Khagaria City': [
          const VillageRecord(
            villageName: 'Khagaria Rural',
            lgdCode: '500358',
            gramPanchayat: 'Khagaria GP',
            policeStationPostOffice: 'Khagaria PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khagaria North',
            lgdCode: '500359',
            gramPanchayat: 'Khagaria Ward 1',
            policeStationPostOffice: 'Khagaria PS / PO',
          ),
        ],
        'Khagaria Block': [
          const VillageRecord(
            villageName: 'Khagaria East',
            lgdCode: '500360',
            gramPanchayat: 'Khagaria East GP',
            policeStationPostOffice: 'Khagaria Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khagaria South',
            lgdCode: '500361',
            gramPanchayat: 'Khagaria South GP',
            policeStationPostOffice: 'Khagaria Rural PS',
          ),
        ],
      },
      'Kishanganj': {

        'Kishanganj City': [
          const VillageRecord(
            villageName: 'Kishanganj Rural',
            lgdCode: '500362',
            gramPanchayat: 'Kishanganj GP',
            policeStationPostOffice: 'Kishanganj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kishanganj North',
            lgdCode: '500363',
            gramPanchayat: 'Kishanganj Ward 1',
            policeStationPostOffice: 'Kishanganj PS / PO',
          ),
        ],
        'Kishanganj Block': [
          const VillageRecord(
            villageName: 'Kishanganj East',
            lgdCode: '500364',
            gramPanchayat: 'Kishanganj East GP',
            policeStationPostOffice: 'Kishanganj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kishanganj South',
            lgdCode: '500365',
            gramPanchayat: 'Kishanganj South GP',
            policeStationPostOffice: 'Kishanganj Rural PS',
          ),
        ],
      },
      'Lakhisarai': {

        'Lakhisarai City': [
          const VillageRecord(
            villageName: 'Lakhisarai Rural',
            lgdCode: '500366',
            gramPanchayat: 'Lakhisarai GP',
            policeStationPostOffice: 'Lakhisarai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lakhisarai North',
            lgdCode: '500367',
            gramPanchayat: 'Lakhisarai Ward 1',
            policeStationPostOffice: 'Lakhisarai PS / PO',
          ),
        ],
        'Lakhisarai Block': [
          const VillageRecord(
            villageName: 'Lakhisarai East',
            lgdCode: '500368',
            gramPanchayat: 'Lakhisarai East GP',
            policeStationPostOffice: 'Lakhisarai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lakhisarai South',
            lgdCode: '500369',
            gramPanchayat: 'Lakhisarai South GP',
            policeStationPostOffice: 'Lakhisarai Rural PS',
          ),
        ],
      },
      'Madhepura': {

        'Madhepura City': [
          const VillageRecord(
            villageName: 'Madhepura Rural',
            lgdCode: '500370',
            gramPanchayat: 'Madhepura GP',
            policeStationPostOffice: 'Madhepura PS / PO',
          ),
          const VillageRecord(
            villageName: 'Madhepura North',
            lgdCode: '500371',
            gramPanchayat: 'Madhepura Ward 1',
            policeStationPostOffice: 'Madhepura PS / PO',
          ),
        ],
        'Madhepura Block': [
          const VillageRecord(
            villageName: 'Madhepura East',
            lgdCode: '500372',
            gramPanchayat: 'Madhepura East GP',
            policeStationPostOffice: 'Madhepura Rural PS',
          ),
          const VillageRecord(
            villageName: 'Madhepura South',
            lgdCode: '500373',
            gramPanchayat: 'Madhepura South GP',
            policeStationPostOffice: 'Madhepura Rural PS',
          ),
        ],
      },
      'Madhubani': {

        'Madhubani City': [
          const VillageRecord(
            villageName: 'Madhubani Rural',
            lgdCode: '500374',
            gramPanchayat: 'Madhubani GP',
            policeStationPostOffice: 'Madhubani PS / PO',
          ),
          const VillageRecord(
            villageName: 'Madhubani North',
            lgdCode: '500375',
            gramPanchayat: 'Madhubani Ward 1',
            policeStationPostOffice: 'Madhubani PS / PO',
          ),
        ],
        'Madhubani Block': [
          const VillageRecord(
            villageName: 'Madhubani East',
            lgdCode: '500376',
            gramPanchayat: 'Madhubani East GP',
            policeStationPostOffice: 'Madhubani Rural PS',
          ),
          const VillageRecord(
            villageName: 'Madhubani South',
            lgdCode: '500377',
            gramPanchayat: 'Madhubani South GP',
            policeStationPostOffice: 'Madhubani Rural PS',
          ),
        ],
      },
      'Munger': {

        'Munger City': [
          const VillageRecord(
            villageName: 'Munger Rural',
            lgdCode: '500378',
            gramPanchayat: 'Munger GP',
            policeStationPostOffice: 'Munger PS / PO',
          ),
          const VillageRecord(
            villageName: 'Munger North',
            lgdCode: '500379',
            gramPanchayat: 'Munger Ward 1',
            policeStationPostOffice: 'Munger PS / PO',
          ),
        ],
        'Munger Block': [
          const VillageRecord(
            villageName: 'Munger East',
            lgdCode: '500380',
            gramPanchayat: 'Munger East GP',
            policeStationPostOffice: 'Munger Rural PS',
          ),
          const VillageRecord(
            villageName: 'Munger South',
            lgdCode: '500381',
            gramPanchayat: 'Munger South GP',
            policeStationPostOffice: 'Munger Rural PS',
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
      'Nalanda': {

        'Nalanda City': [
          const VillageRecord(
            villageName: 'Nalanda Rural',
            lgdCode: '500382',
            gramPanchayat: 'Nalanda GP',
            policeStationPostOffice: 'Nalanda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nalanda North',
            lgdCode: '500383',
            gramPanchayat: 'Nalanda Ward 1',
            policeStationPostOffice: 'Nalanda PS / PO',
          ),
        ],
        'Nalanda Block': [
          const VillageRecord(
            villageName: 'Nalanda East',
            lgdCode: '500384',
            gramPanchayat: 'Nalanda East GP',
            policeStationPostOffice: 'Nalanda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nalanda South',
            lgdCode: '500385',
            gramPanchayat: 'Nalanda South GP',
            policeStationPostOffice: 'Nalanda Rural PS',
          ),
        ],
      },
      'Nawada': {

        'Nawada City': [
          const VillageRecord(
            villageName: 'Nawada Rural',
            lgdCode: '500386',
            gramPanchayat: 'Nawada GP',
            policeStationPostOffice: 'Nawada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nawada North',
            lgdCode: '500387',
            gramPanchayat: 'Nawada Ward 1',
            policeStationPostOffice: 'Nawada PS / PO',
          ),
        ],
        'Nawada Block': [
          const VillageRecord(
            villageName: 'Nawada East',
            lgdCode: '500388',
            gramPanchayat: 'Nawada East GP',
            policeStationPostOffice: 'Nawada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nawada South',
            lgdCode: '500389',
            gramPanchayat: 'Nawada South GP',
            policeStationPostOffice: 'Nawada Rural PS',
          ),
        ],
      },
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
      'Purnia': {

        'Purnia City': [
          const VillageRecord(
            villageName: 'Purnia Rural',
            lgdCode: '500390',
            gramPanchayat: 'Purnia GP',
            policeStationPostOffice: 'Purnia PS / PO',
          ),
          const VillageRecord(
            villageName: 'Purnia North',
            lgdCode: '500391',
            gramPanchayat: 'Purnia Ward 1',
            policeStationPostOffice: 'Purnia PS / PO',
          ),
        ],
        'Purnia Block': [
          const VillageRecord(
            villageName: 'Purnia East',
            lgdCode: '500392',
            gramPanchayat: 'Purnia East GP',
            policeStationPostOffice: 'Purnia Rural PS',
          ),
          const VillageRecord(
            villageName: 'Purnia South',
            lgdCode: '500393',
            gramPanchayat: 'Purnia South GP',
            policeStationPostOffice: 'Purnia Rural PS',
          ),
        ],
      },
      'Rohtas': {

        'Rohtas City': [
          const VillageRecord(
            villageName: 'Rohtas Rural',
            lgdCode: '500394',
            gramPanchayat: 'Rohtas GP',
            policeStationPostOffice: 'Rohtas PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rohtas North',
            lgdCode: '500395',
            gramPanchayat: 'Rohtas Ward 1',
            policeStationPostOffice: 'Rohtas PS / PO',
          ),
        ],
        'Rohtas Block': [
          const VillageRecord(
            villageName: 'Rohtas East',
            lgdCode: '500396',
            gramPanchayat: 'Rohtas East GP',
            policeStationPostOffice: 'Rohtas Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rohtas South',
            lgdCode: '500397',
            gramPanchayat: 'Rohtas South GP',
            policeStationPostOffice: 'Rohtas Rural PS',
          ),
        ],
      },
      'Saharsa': {

        'Saharsa City': [
          const VillageRecord(
            villageName: 'Saharsa Rural',
            lgdCode: '500398',
            gramPanchayat: 'Saharsa GP',
            policeStationPostOffice: 'Saharsa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Saharsa North',
            lgdCode: '500399',
            gramPanchayat: 'Saharsa Ward 1',
            policeStationPostOffice: 'Saharsa PS / PO',
          ),
        ],
        'Saharsa Block': [
          const VillageRecord(
            villageName: 'Saharsa East',
            lgdCode: '500400',
            gramPanchayat: 'Saharsa East GP',
            policeStationPostOffice: 'Saharsa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Saharsa South',
            lgdCode: '500401',
            gramPanchayat: 'Saharsa South GP',
            policeStationPostOffice: 'Saharsa Rural PS',
          ),
        ],
      },
      'Samastipur': {

        'Samastipur City': [
          const VillageRecord(
            villageName: 'Samastipur Rural',
            lgdCode: '500402',
            gramPanchayat: 'Samastipur GP',
            policeStationPostOffice: 'Samastipur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Samastipur North',
            lgdCode: '500403',
            gramPanchayat: 'Samastipur Ward 1',
            policeStationPostOffice: 'Samastipur PS / PO',
          ),
        ],
        'Samastipur Block': [
          const VillageRecord(
            villageName: 'Samastipur East',
            lgdCode: '500404',
            gramPanchayat: 'Samastipur East GP',
            policeStationPostOffice: 'Samastipur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Samastipur South',
            lgdCode: '500405',
            gramPanchayat: 'Samastipur South GP',
            policeStationPostOffice: 'Samastipur Rural PS',
          ),
        ],
      },
      'Saran': {

        'Saran City': [
          const VillageRecord(
            villageName: 'Saran Rural',
            lgdCode: '500406',
            gramPanchayat: 'Saran GP',
            policeStationPostOffice: 'Saran PS / PO',
          ),
          const VillageRecord(
            villageName: 'Saran North',
            lgdCode: '500407',
            gramPanchayat: 'Saran Ward 1',
            policeStationPostOffice: 'Saran PS / PO',
          ),
        ],
        'Saran Block': [
          const VillageRecord(
            villageName: 'Saran East',
            lgdCode: '500408',
            gramPanchayat: 'Saran East GP',
            policeStationPostOffice: 'Saran Rural PS',
          ),
          const VillageRecord(
            villageName: 'Saran South',
            lgdCode: '500409',
            gramPanchayat: 'Saran South GP',
            policeStationPostOffice: 'Saran Rural PS',
          ),
        ],
      },
      'Sheikhpura': {

        'Sheikhpura City': [
          const VillageRecord(
            villageName: 'Sheikhpura Rural',
            lgdCode: '500410',
            gramPanchayat: 'Sheikhpura GP',
            policeStationPostOffice: 'Sheikhpura PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sheikhpura North',
            lgdCode: '500411',
            gramPanchayat: 'Sheikhpura Ward 1',
            policeStationPostOffice: 'Sheikhpura PS / PO',
          ),
        ],
        'Sheikhpura Block': [
          const VillageRecord(
            villageName: 'Sheikhpura East',
            lgdCode: '500412',
            gramPanchayat: 'Sheikhpura East GP',
            policeStationPostOffice: 'Sheikhpura Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sheikhpura South',
            lgdCode: '500413',
            gramPanchayat: 'Sheikhpura South GP',
            policeStationPostOffice: 'Sheikhpura Rural PS',
          ),
        ],
      },
      'Sheohar': {

        'Sheohar City': [
          const VillageRecord(
            villageName: 'Sheohar Rural',
            lgdCode: '500414',
            gramPanchayat: 'Sheohar GP',
            policeStationPostOffice: 'Sheohar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sheohar North',
            lgdCode: '500415',
            gramPanchayat: 'Sheohar Ward 1',
            policeStationPostOffice: 'Sheohar PS / PO',
          ),
        ],
        'Sheohar Block': [
          const VillageRecord(
            villageName: 'Sheohar East',
            lgdCode: '500416',
            gramPanchayat: 'Sheohar East GP',
            policeStationPostOffice: 'Sheohar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sheohar South',
            lgdCode: '500417',
            gramPanchayat: 'Sheohar South GP',
            policeStationPostOffice: 'Sheohar Rural PS',
          ),
        ],
      },
      'Sitamarhi': {

        'Sitamarhi City': [
          const VillageRecord(
            villageName: 'Sitamarhi Rural',
            lgdCode: '500418',
            gramPanchayat: 'Sitamarhi GP',
            policeStationPostOffice: 'Sitamarhi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sitamarhi North',
            lgdCode: '500419',
            gramPanchayat: 'Sitamarhi Ward 1',
            policeStationPostOffice: 'Sitamarhi PS / PO',
          ),
        ],
        'Sitamarhi Block': [
          const VillageRecord(
            villageName: 'Sitamarhi East',
            lgdCode: '500420',
            gramPanchayat: 'Sitamarhi East GP',
            policeStationPostOffice: 'Sitamarhi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sitamarhi South',
            lgdCode: '500421',
            gramPanchayat: 'Sitamarhi South GP',
            policeStationPostOffice: 'Sitamarhi Rural PS',
          ),
        ],
      },
      'Siwan': {

        'Siwan City': [
          const VillageRecord(
            villageName: 'Siwan Rural',
            lgdCode: '500422',
            gramPanchayat: 'Siwan GP',
            policeStationPostOffice: 'Siwan PS / PO',
          ),
          const VillageRecord(
            villageName: 'Siwan North',
            lgdCode: '500423',
            gramPanchayat: 'Siwan Ward 1',
            policeStationPostOffice: 'Siwan PS / PO',
          ),
        ],
        'Siwan Block': [
          const VillageRecord(
            villageName: 'Siwan East',
            lgdCode: '500424',
            gramPanchayat: 'Siwan East GP',
            policeStationPostOffice: 'Siwan Rural PS',
          ),
          const VillageRecord(
            villageName: 'Siwan South',
            lgdCode: '500425',
            gramPanchayat: 'Siwan South GP',
            policeStationPostOffice: 'Siwan Rural PS',
          ),
        ],
      },
      'Supaul': {

        'Supaul City': [
          const VillageRecord(
            villageName: 'Supaul Rural',
            lgdCode: '500426',
            gramPanchayat: 'Supaul GP',
            policeStationPostOffice: 'Supaul PS / PO',
          ),
          const VillageRecord(
            villageName: 'Supaul North',
            lgdCode: '500427',
            gramPanchayat: 'Supaul Ward 1',
            policeStationPostOffice: 'Supaul PS / PO',
          ),
        ],
        'Supaul Block': [
          const VillageRecord(
            villageName: 'Supaul East',
            lgdCode: '500428',
            gramPanchayat: 'Supaul East GP',
            policeStationPostOffice: 'Supaul Rural PS',
          ),
          const VillageRecord(
            villageName: 'Supaul South',
            lgdCode: '500429',
            gramPanchayat: 'Supaul South GP',
            policeStationPostOffice: 'Supaul Rural PS',
          ),
        ],
      },
      'Vaishali': {

        'Vaishali City': [
          const VillageRecord(
            villageName: 'Vaishali Rural',
            lgdCode: '500430',
            gramPanchayat: 'Vaishali GP',
            policeStationPostOffice: 'Vaishali PS / PO',
          ),
          const VillageRecord(
            villageName: 'Vaishali North',
            lgdCode: '500431',
            gramPanchayat: 'Vaishali Ward 1',
            policeStationPostOffice: 'Vaishali PS / PO',
          ),
        ],
        'Vaishali Block': [
          const VillageRecord(
            villageName: 'Vaishali East',
            lgdCode: '500432',
            gramPanchayat: 'Vaishali East GP',
            policeStationPostOffice: 'Vaishali Rural PS',
          ),
          const VillageRecord(
            villageName: 'Vaishali South',
            lgdCode: '500433',
            gramPanchayat: 'Vaishali South GP',
            policeStationPostOffice: 'Vaishali Rural PS',
          ),
        ],
      },
      'West Champaran': {

        'West Champaran City': [
          const VillageRecord(
            villageName: 'West Champaran Rural',
            lgdCode: '500434',
            gramPanchayat: 'West Champaran GP',
            policeStationPostOffice: 'West Champaran PS / PO',
          ),
          const VillageRecord(
            villageName: 'West Champaran North',
            lgdCode: '500435',
            gramPanchayat: 'West Champaran Ward 1',
            policeStationPostOffice: 'West Champaran PS / PO',
          ),
        ],
        'West Champaran Block': [
          const VillageRecord(
            villageName: 'West Champaran East',
            lgdCode: '500436',
            gramPanchayat: 'West Champaran East GP',
            policeStationPostOffice: 'West Champaran Rural PS',
          ),
          const VillageRecord(
            villageName: 'West Champaran South',
            lgdCode: '500437',
            gramPanchayat: 'West Champaran South GP',
            policeStationPostOffice: 'West Champaran Rural PS',
          ),
        ],
      },
    },
    'Chhattisgarh': {
      'Balod': {

        'Balod City': [
          const VillageRecord(
            villageName: 'Balod Rural',
            lgdCode: '500438',
            gramPanchayat: 'Balod GP',
            policeStationPostOffice: 'Balod PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balod North',
            lgdCode: '500439',
            gramPanchayat: 'Balod Ward 1',
            policeStationPostOffice: 'Balod PS / PO',
          ),
        ],
        'Balod Block': [
          const VillageRecord(
            villageName: 'Balod East',
            lgdCode: '500440',
            gramPanchayat: 'Balod East GP',
            policeStationPostOffice: 'Balod Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balod South',
            lgdCode: '500441',
            gramPanchayat: 'Balod South GP',
            policeStationPostOffice: 'Balod Rural PS',
          ),
        ],
      },
      'Baloda Bazar': {

        'Balod City': [
          const VillageRecord(
            villageName: 'Balod Rural',
            lgdCode: '500438',
            gramPanchayat: 'Balod GP',
            policeStationPostOffice: 'Balod PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balod North',
            lgdCode: '500439',
            gramPanchayat: 'Balod Ward 1',
            policeStationPostOffice: 'Balod PS / PO',
          ),
        ],
        'Balod Block': [
          const VillageRecord(
            villageName: 'Balod East',
            lgdCode: '500440',
            gramPanchayat: 'Balod East GP',
            policeStationPostOffice: 'Balod Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balod South',
            lgdCode: '500441',
            gramPanchayat: 'Balod South GP',
            policeStationPostOffice: 'Balod Rural PS',
          ),
        ],
      },
      'Balrampur': {

        'Balrampur City': [
          const VillageRecord(
            villageName: 'Balrampur Rural',
            lgdCode: '500446',
            gramPanchayat: 'Balrampur GP',
            policeStationPostOffice: 'Balrampur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balrampur North',
            lgdCode: '500447',
            gramPanchayat: 'Balrampur Ward 1',
            policeStationPostOffice: 'Balrampur PS / PO',
          ),
        ],
        'Balrampur Block': [
          const VillageRecord(
            villageName: 'Balrampur East',
            lgdCode: '500448',
            gramPanchayat: 'Balrampur East GP',
            policeStationPostOffice: 'Balrampur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balrampur South',
            lgdCode: '500449',
            gramPanchayat: 'Balrampur South GP',
            policeStationPostOffice: 'Balrampur Rural PS',
          ),
        ],
      },
      'Bastar': {

        'Bastar City': [
          const VillageRecord(
            villageName: 'Bastar Rural',
            lgdCode: '500450',
            gramPanchayat: 'Bastar GP',
            policeStationPostOffice: 'Bastar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bastar North',
            lgdCode: '500451',
            gramPanchayat: 'Bastar Ward 1',
            policeStationPostOffice: 'Bastar PS / PO',
          ),
        ],
        'Bastar Block': [
          const VillageRecord(
            villageName: 'Bastar East',
            lgdCode: '500452',
            gramPanchayat: 'Bastar East GP',
            policeStationPostOffice: 'Bastar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bastar South',
            lgdCode: '500453',
            gramPanchayat: 'Bastar South GP',
            policeStationPostOffice: 'Bastar Rural PS',
          ),
        ],
      },
      'Bemetara': {

        'Bemetara City': [
          const VillageRecord(
            villageName: 'Bemetara Rural',
            lgdCode: '500454',
            gramPanchayat: 'Bemetara GP',
            policeStationPostOffice: 'Bemetara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bemetara North',
            lgdCode: '500455',
            gramPanchayat: 'Bemetara Ward 1',
            policeStationPostOffice: 'Bemetara PS / PO',
          ),
        ],
        'Bemetara Block': [
          const VillageRecord(
            villageName: 'Bemetara East',
            lgdCode: '500456',
            gramPanchayat: 'Bemetara East GP',
            policeStationPostOffice: 'Bemetara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bemetara South',
            lgdCode: '500457',
            gramPanchayat: 'Bemetara South GP',
            policeStationPostOffice: 'Bemetara Rural PS',
          ),
        ],
      },
      'Bijapur': {

        'Bijapur City': [
          const VillageRecord(
            villageName: 'Bijapur Rural',
            lgdCode: '500458',
            gramPanchayat: 'Bijapur GP',
            policeStationPostOffice: 'Bijapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bijapur North',
            lgdCode: '500459',
            gramPanchayat: 'Bijapur Ward 1',
            policeStationPostOffice: 'Bijapur PS / PO',
          ),
        ],
        'Bijapur Block': [
          const VillageRecord(
            villageName: 'Bijapur East',
            lgdCode: '500460',
            gramPanchayat: 'Bijapur East GP',
            policeStationPostOffice: 'Bijapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bijapur South',
            lgdCode: '500461',
            gramPanchayat: 'Bijapur South GP',
            policeStationPostOffice: 'Bijapur Rural PS',
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
      'Dantewada': {

        'Dantewada City': [
          const VillageRecord(
            villageName: 'Dantewada Rural',
            lgdCode: '500462',
            gramPanchayat: 'Dantewada GP',
            policeStationPostOffice: 'Dantewada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dantewada North',
            lgdCode: '500463',
            gramPanchayat: 'Dantewada Ward 1',
            policeStationPostOffice: 'Dantewada PS / PO',
          ),
        ],
        'Dantewada Block': [
          const VillageRecord(
            villageName: 'Dantewada East',
            lgdCode: '500464',
            gramPanchayat: 'Dantewada East GP',
            policeStationPostOffice: 'Dantewada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dantewada South',
            lgdCode: '500465',
            gramPanchayat: 'Dantewada South GP',
            policeStationPostOffice: 'Dantewada Rural PS',
          ),
        ],
      },
      'Dhamtari': {

        'Dhamtari City': [
          const VillageRecord(
            villageName: 'Dhamtari Rural',
            lgdCode: '500466',
            gramPanchayat: 'Dhamtari GP',
            policeStationPostOffice: 'Dhamtari PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dhamtari North',
            lgdCode: '500467',
            gramPanchayat: 'Dhamtari Ward 1',
            policeStationPostOffice: 'Dhamtari PS / PO',
          ),
        ],
        'Dhamtari Block': [
          const VillageRecord(
            villageName: 'Dhamtari East',
            lgdCode: '500468',
            gramPanchayat: 'Dhamtari East GP',
            policeStationPostOffice: 'Dhamtari Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dhamtari South',
            lgdCode: '500469',
            gramPanchayat: 'Dhamtari South GP',
            policeStationPostOffice: 'Dhamtari Rural PS',
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
      'Gariaband': {

        'Gariaband City': [
          const VillageRecord(
            villageName: 'Gariaband Rural',
            lgdCode: '500470',
            gramPanchayat: 'Gariaband GP',
            policeStationPostOffice: 'Gariaband PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gariaband North',
            lgdCode: '500471',
            gramPanchayat: 'Gariaband Ward 1',
            policeStationPostOffice: 'Gariaband PS / PO',
          ),
        ],
        'Gariaband Block': [
          const VillageRecord(
            villageName: 'Gariaband East',
            lgdCode: '500472',
            gramPanchayat: 'Gariaband East GP',
            policeStationPostOffice: 'Gariaband Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gariaband South',
            lgdCode: '500473',
            gramPanchayat: 'Gariaband South GP',
            policeStationPostOffice: 'Gariaband Rural PS',
          ),
        ],
      },
      'Gaurela Pendra Marwahi': {

        'Gaurela Pendra Marwahi City': [
          const VillageRecord(
            villageName: 'Gaurela Pendra Marwahi Rural',
            lgdCode: '500474',
            gramPanchayat: 'Gaurela Pendra Marwahi GP',
            policeStationPostOffice: 'Gaurela Pendra Marwahi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gaurela Pendra Marwahi North',
            lgdCode: '500475',
            gramPanchayat: 'Gaurela Pendra Marwahi Ward 1',
            policeStationPostOffice: 'Gaurela Pendra Marwahi PS / PO',
          ),
        ],
        'Gaurela Pendra Marwahi Block': [
          const VillageRecord(
            villageName: 'Gaurela Pendra Marwahi East',
            lgdCode: '500476',
            gramPanchayat: 'Gaurela Pendra Marwahi East GP',
            policeStationPostOffice: 'Gaurela Pendra Marwahi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gaurela Pendra Marwahi South',
            lgdCode: '500477',
            gramPanchayat: 'Gaurela Pendra Marwahi South GP',
            policeStationPostOffice: 'Gaurela Pendra Marwahi Rural PS',
          ),
        ],
      },
      'Janjgir-Champa': {

        'Janjgir-Champa City': [
          const VillageRecord(
            villageName: 'Janjgir-Champa Rural',
            lgdCode: '500478',
            gramPanchayat: 'Janjgir-Champa GP',
            policeStationPostOffice: 'Janjgir-Champa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Janjgir-Champa North',
            lgdCode: '500479',
            gramPanchayat: 'Janjgir-Champa Ward 1',
            policeStationPostOffice: 'Janjgir-Champa PS / PO',
          ),
        ],
        'Janjgir-Champa Block': [
          const VillageRecord(
            villageName: 'Janjgir-Champa East',
            lgdCode: '500480',
            gramPanchayat: 'Janjgir-Champa East GP',
            policeStationPostOffice: 'Janjgir-Champa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Janjgir-Champa South',
            lgdCode: '500481',
            gramPanchayat: 'Janjgir-Champa South GP',
            policeStationPostOffice: 'Janjgir-Champa Rural PS',
          ),
        ],
      },
      'Jashpur': {

        'Jashpur City': [
          const VillageRecord(
            villageName: 'Jashpur Rural',
            lgdCode: '500482',
            gramPanchayat: 'Jashpur GP',
            policeStationPostOffice: 'Jashpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jashpur North',
            lgdCode: '500483',
            gramPanchayat: 'Jashpur Ward 1',
            policeStationPostOffice: 'Jashpur PS / PO',
          ),
        ],
        'Jashpur Block': [
          const VillageRecord(
            villageName: 'Jashpur East',
            lgdCode: '500484',
            gramPanchayat: 'Jashpur East GP',
            policeStationPostOffice: 'Jashpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jashpur South',
            lgdCode: '500485',
            gramPanchayat: 'Jashpur South GP',
            policeStationPostOffice: 'Jashpur Rural PS',
          ),
        ],
      },
      'Kabirdham': {

        'Kabirdham City': [
          const VillageRecord(
            villageName: 'Kabirdham Rural',
            lgdCode: '500486',
            gramPanchayat: 'Kabirdham GP',
            policeStationPostOffice: 'Kabirdham PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kabirdham North',
            lgdCode: '500487',
            gramPanchayat: 'Kabirdham Ward 1',
            policeStationPostOffice: 'Kabirdham PS / PO',
          ),
        ],
        'Kabirdham Block': [
          const VillageRecord(
            villageName: 'Kabirdham East',
            lgdCode: '500488',
            gramPanchayat: 'Kabirdham East GP',
            policeStationPostOffice: 'Kabirdham Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kabirdham South',
            lgdCode: '500489',
            gramPanchayat: 'Kabirdham South GP',
            policeStationPostOffice: 'Kabirdham Rural PS',
          ),
        ],
      },
      'Kanker': {

        'Kanker City': [
          const VillageRecord(
            villageName: 'Kanker Rural',
            lgdCode: '500490',
            gramPanchayat: 'Kanker GP',
            policeStationPostOffice: 'Kanker PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kanker North',
            lgdCode: '500491',
            gramPanchayat: 'Kanker Ward 1',
            policeStationPostOffice: 'Kanker PS / PO',
          ),
        ],
        'Kanker Block': [
          const VillageRecord(
            villageName: 'Kanker East',
            lgdCode: '500492',
            gramPanchayat: 'Kanker East GP',
            policeStationPostOffice: 'Kanker Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kanker South',
            lgdCode: '500493',
            gramPanchayat: 'Kanker South GP',
            policeStationPostOffice: 'Kanker Rural PS',
          ),
        ],
      },
      'Kondagaon': {

        'Kondagaon City': [
          const VillageRecord(
            villageName: 'Kondagaon Rural',
            lgdCode: '500494',
            gramPanchayat: 'Kondagaon GP',
            policeStationPostOffice: 'Kondagaon PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kondagaon North',
            lgdCode: '500495',
            gramPanchayat: 'Kondagaon Ward 1',
            policeStationPostOffice: 'Kondagaon PS / PO',
          ),
        ],
        'Kondagaon Block': [
          const VillageRecord(
            villageName: 'Kondagaon East',
            lgdCode: '500496',
            gramPanchayat: 'Kondagaon East GP',
            policeStationPostOffice: 'Kondagaon Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kondagaon South',
            lgdCode: '500497',
            gramPanchayat: 'Kondagaon South GP',
            policeStationPostOffice: 'Kondagaon Rural PS',
          ),
        ],
      },
      'Korba': {

        'Korba City': [
          const VillageRecord(
            villageName: 'Korba Rural',
            lgdCode: '500498',
            gramPanchayat: 'Korba GP',
            policeStationPostOffice: 'Korba PS / PO',
          ),
          const VillageRecord(
            villageName: 'Korba North',
            lgdCode: '500499',
            gramPanchayat: 'Korba Ward 1',
            policeStationPostOffice: 'Korba PS / PO',
          ),
        ],
        'Korba Block': [
          const VillageRecord(
            villageName: 'Korba East',
            lgdCode: '500500',
            gramPanchayat: 'Korba East GP',
            policeStationPostOffice: 'Korba Rural PS',
          ),
          const VillageRecord(
            villageName: 'Korba South',
            lgdCode: '500501',
            gramPanchayat: 'Korba South GP',
            policeStationPostOffice: 'Korba Rural PS',
          ),
        ],
      },
      'Koriya': {

        'Koriya City': [
          const VillageRecord(
            villageName: 'Koriya Rural',
            lgdCode: '500502',
            gramPanchayat: 'Koriya GP',
            policeStationPostOffice: 'Koriya PS / PO',
          ),
          const VillageRecord(
            villageName: 'Koriya North',
            lgdCode: '500503',
            gramPanchayat: 'Koriya Ward 1',
            policeStationPostOffice: 'Koriya PS / PO',
          ),
        ],
        'Koriya Block': [
          const VillageRecord(
            villageName: 'Koriya East',
            lgdCode: '500504',
            gramPanchayat: 'Koriya East GP',
            policeStationPostOffice: 'Koriya Rural PS',
          ),
          const VillageRecord(
            villageName: 'Koriya South',
            lgdCode: '500505',
            gramPanchayat: 'Koriya South GP',
            policeStationPostOffice: 'Koriya Rural PS',
          ),
        ],
      },
      'Mahasamund': {

        'Mahasamund City': [
          const VillageRecord(
            villageName: 'Mahasamund Rural',
            lgdCode: '500506',
            gramPanchayat: 'Mahasamund GP',
            policeStationPostOffice: 'Mahasamund PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mahasamund North',
            lgdCode: '500507',
            gramPanchayat: 'Mahasamund Ward 1',
            policeStationPostOffice: 'Mahasamund PS / PO',
          ),
        ],
        'Mahasamund Block': [
          const VillageRecord(
            villageName: 'Mahasamund East',
            lgdCode: '500508',
            gramPanchayat: 'Mahasamund East GP',
            policeStationPostOffice: 'Mahasamund Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mahasamund South',
            lgdCode: '500509',
            gramPanchayat: 'Mahasamund South GP',
            policeStationPostOffice: 'Mahasamund Rural PS',
          ),
        ],
      },
      'Manendragarh-Chirmiri-Bharatpur': {

        'Manendragarh-Chirmiri-Bharatpur City': [
          const VillageRecord(
            villageName: 'Manendragarh-Chirmiri-Bharatpur Rural',
            lgdCode: '500510',
            gramPanchayat: 'Manendragarh-Chirmiri-Bharatpur GP',
            policeStationPostOffice: 'Manendragarh-Chirmiri-Bharatpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Manendragarh-Chirmiri-Bharatpur North',
            lgdCode: '500511',
            gramPanchayat: 'Manendragarh-Chirmiri-Bharatpur Ward 1',
            policeStationPostOffice: 'Manendragarh-Chirmiri-Bharatpur PS / PO',
          ),
        ],
        'Manendragarh-Chirmiri-Bharatpur Block': [
          const VillageRecord(
            villageName: 'Manendragarh-Chirmiri-Bharatpur East',
            lgdCode: '500512',
            gramPanchayat: 'Manendragarh-Chirmiri-Bharatpur East GP',
            policeStationPostOffice: 'Manendragarh-Chirmiri-Bharatpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Manendragarh-Chirmiri-Bharatpur South',
            lgdCode: '500513',
            gramPanchayat: 'Manendragarh-Chirmiri-Bharatpur South GP',
            policeStationPostOffice: 'Manendragarh-Chirmiri-Bharatpur Rural PS',
          ),
        ],
      },
      'Mohla-Manpur-Ambagarh Chowki': {

        'Mohla-Manpur-Ambagarh Chowki City': [
          const VillageRecord(
            villageName: 'Mohla-Manpur-Ambagarh Chowki Rural',
            lgdCode: '500514',
            gramPanchayat: 'Mohla-Manpur-Ambagarh Chowki GP',
            policeStationPostOffice: 'Mohla-Manpur-Ambagarh Chowki PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mohla-Manpur-Ambagarh Chowki North',
            lgdCode: '500515',
            gramPanchayat: 'Mohla-Manpur-Ambagarh Chowki Ward 1',
            policeStationPostOffice: 'Mohla-Manpur-Ambagarh Chowki PS / PO',
          ),
        ],
        'Mohla-Manpur-Ambagarh Chowki Block': [
          const VillageRecord(
            villageName: 'Mohla-Manpur-Ambagarh Chowki East',
            lgdCode: '500516',
            gramPanchayat: 'Mohla-Manpur-Ambagarh Chowki East GP',
            policeStationPostOffice: 'Mohla-Manpur-Ambagarh Chowki Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mohla-Manpur-Ambagarh Chowki South',
            lgdCode: '500517',
            gramPanchayat: 'Mohla-Manpur-Ambagarh Chowki South GP',
            policeStationPostOffice: 'Mohla-Manpur-Ambagarh Chowki Rural PS',
          ),
        ],
      },
      'Mungeli': {

        'Mungeli City': [
          const VillageRecord(
            villageName: 'Mungeli Rural',
            lgdCode: '500518',
            gramPanchayat: 'Mungeli GP',
            policeStationPostOffice: 'Mungeli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mungeli North',
            lgdCode: '500519',
            gramPanchayat: 'Mungeli Ward 1',
            policeStationPostOffice: 'Mungeli PS / PO',
          ),
        ],
        'Mungeli Block': [
          const VillageRecord(
            villageName: 'Mungeli East',
            lgdCode: '500520',
            gramPanchayat: 'Mungeli East GP',
            policeStationPostOffice: 'Mungeli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mungeli South',
            lgdCode: '500521',
            gramPanchayat: 'Mungeli South GP',
            policeStationPostOffice: 'Mungeli Rural PS',
          ),
        ],
      },
      'Narayanpur': {

        'Narayanpur City': [
          const VillageRecord(
            villageName: 'Narayanpur Rural',
            lgdCode: '500522',
            gramPanchayat: 'Narayanpur GP',
            policeStationPostOffice: 'Narayanpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Narayanpur North',
            lgdCode: '500523',
            gramPanchayat: 'Narayanpur Ward 1',
            policeStationPostOffice: 'Narayanpur PS / PO',
          ),
        ],
        'Narayanpur Block': [
          const VillageRecord(
            villageName: 'Narayanpur East',
            lgdCode: '500524',
            gramPanchayat: 'Narayanpur East GP',
            policeStationPostOffice: 'Narayanpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Narayanpur South',
            lgdCode: '500525',
            gramPanchayat: 'Narayanpur South GP',
            policeStationPostOffice: 'Narayanpur Rural PS',
          ),
        ],
      },
      'Raigarh': {

        'Raigarh City': [
          const VillageRecord(
            villageName: 'Raigarh Rural',
            lgdCode: '500526',
            gramPanchayat: 'Raigarh GP',
            policeStationPostOffice: 'Raigarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Raigarh North',
            lgdCode: '500527',
            gramPanchayat: 'Raigarh Ward 1',
            policeStationPostOffice: 'Raigarh PS / PO',
          ),
        ],
        'Raigarh Block': [
          const VillageRecord(
            villageName: 'Raigarh East',
            lgdCode: '500528',
            gramPanchayat: 'Raigarh East GP',
            policeStationPostOffice: 'Raigarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Raigarh South',
            lgdCode: '500529',
            gramPanchayat: 'Raigarh South GP',
            policeStationPostOffice: 'Raigarh Rural PS',
          ),
        ],
      },
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
      'Rajnandgaon': {

        'Rajnandgaon City': [
          const VillageRecord(
            villageName: 'Rajnandgaon Rural',
            lgdCode: '500530',
            gramPanchayat: 'Rajnandgaon GP',
            policeStationPostOffice: 'Rajnandgaon PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rajnandgaon North',
            lgdCode: '500531',
            gramPanchayat: 'Rajnandgaon Ward 1',
            policeStationPostOffice: 'Rajnandgaon PS / PO',
          ),
        ],
        'Rajnandgaon Block': [
          const VillageRecord(
            villageName: 'Rajnandgaon East',
            lgdCode: '500532',
            gramPanchayat: 'Rajnandgaon East GP',
            policeStationPostOffice: 'Rajnandgaon Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rajnandgaon South',
            lgdCode: '500533',
            gramPanchayat: 'Rajnandgaon South GP',
            policeStationPostOffice: 'Rajnandgaon Rural PS',
          ),
        ],
      },
      'Sarangarh-Bilaigarh': {

        'Sarangarh-Bilaigarh City': [
          const VillageRecord(
            villageName: 'Sarangarh-Bilaigarh Rural',
            lgdCode: '500534',
            gramPanchayat: 'Sarangarh-Bilaigarh GP',
            policeStationPostOffice: 'Sarangarh-Bilaigarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sarangarh-Bilaigarh North',
            lgdCode: '500535',
            gramPanchayat: 'Sarangarh-Bilaigarh Ward 1',
            policeStationPostOffice: 'Sarangarh-Bilaigarh PS / PO',
          ),
        ],
        'Sarangarh-Bilaigarh Block': [
          const VillageRecord(
            villageName: 'Sarangarh-Bilaigarh East',
            lgdCode: '500536',
            gramPanchayat: 'Sarangarh-Bilaigarh East GP',
            policeStationPostOffice: 'Sarangarh-Bilaigarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sarangarh-Bilaigarh South',
            lgdCode: '500537',
            gramPanchayat: 'Sarangarh-Bilaigarh South GP',
            policeStationPostOffice: 'Sarangarh-Bilaigarh Rural PS',
          ),
        ],
      },
      'Sakti': {

        'Sakti City': [
          const VillageRecord(
            villageName: 'Sakti Rural',
            lgdCode: '500538',
            gramPanchayat: 'Sakti GP',
            policeStationPostOffice: 'Sakti PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sakti North',
            lgdCode: '500539',
            gramPanchayat: 'Sakti Ward 1',
            policeStationPostOffice: 'Sakti PS / PO',
          ),
        ],
        'Sakti Block': [
          const VillageRecord(
            villageName: 'Sakti East',
            lgdCode: '500540',
            gramPanchayat: 'Sakti East GP',
            policeStationPostOffice: 'Sakti Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sakti South',
            lgdCode: '500541',
            gramPanchayat: 'Sakti South GP',
            policeStationPostOffice: 'Sakti Rural PS',
          ),
        ],
      },
      'Sukma': {

        'Sukma City': [
          const VillageRecord(
            villageName: 'Sukma Rural',
            lgdCode: '500542',
            gramPanchayat: 'Sukma GP',
            policeStationPostOffice: 'Sukma PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sukma North',
            lgdCode: '500543',
            gramPanchayat: 'Sukma Ward 1',
            policeStationPostOffice: 'Sukma PS / PO',
          ),
        ],
        'Sukma Block': [
          const VillageRecord(
            villageName: 'Sukma East',
            lgdCode: '500544',
            gramPanchayat: 'Sukma East GP',
            policeStationPostOffice: 'Sukma Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sukma South',
            lgdCode: '500545',
            gramPanchayat: 'Sukma South GP',
            policeStationPostOffice: 'Sukma Rural PS',
          ),
        ],
      },
      'Surajpur': {

        'Surajpur City': [
          const VillageRecord(
            villageName: 'Surajpur Rural',
            lgdCode: '500546',
            gramPanchayat: 'Surajpur GP',
            policeStationPostOffice: 'Surajpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Surajpur North',
            lgdCode: '500547',
            gramPanchayat: 'Surajpur Ward 1',
            policeStationPostOffice: 'Surajpur PS / PO',
          ),
        ],
        'Surajpur Block': [
          const VillageRecord(
            villageName: 'Surajpur East',
            lgdCode: '500548',
            gramPanchayat: 'Surajpur East GP',
            policeStationPostOffice: 'Surajpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Surajpur South',
            lgdCode: '500549',
            gramPanchayat: 'Surajpur South GP',
            policeStationPostOffice: 'Surajpur Rural PS',
          ),
        ],
      },
      'Surguja': {

        'Surguja City': [
          const VillageRecord(
            villageName: 'Surguja Rural',
            lgdCode: '500550',
            gramPanchayat: 'Surguja GP',
            policeStationPostOffice: 'Surguja PS / PO',
          ),
          const VillageRecord(
            villageName: 'Surguja North',
            lgdCode: '500551',
            gramPanchayat: 'Surguja Ward 1',
            policeStationPostOffice: 'Surguja PS / PO',
          ),
        ],
        'Surguja Block': [
          const VillageRecord(
            villageName: 'Surguja East',
            lgdCode: '500552',
            gramPanchayat: 'Surguja East GP',
            policeStationPostOffice: 'Surguja Rural PS',
          ),
          const VillageRecord(
            villageName: 'Surguja South',
            lgdCode: '500553',
            gramPanchayat: 'Surguja South GP',
            policeStationPostOffice: 'Surguja Rural PS',
          ),
        ],
      },
      'Khairagarh-Chhuikhadan-Gandai': {

        'Khairagarh-Chhuikhadan-Gandai City': [
          const VillageRecord(
            villageName: 'Khairagarh-Chhuikhadan-Gandai Rural',
            lgdCode: '500554',
            gramPanchayat: 'Khairagarh-Chhuikhadan-Gandai GP',
            policeStationPostOffice: 'Khairagarh-Chhuikhadan-Gandai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khairagarh-Chhuikhadan-Gandai North',
            lgdCode: '500555',
            gramPanchayat: 'Khairagarh-Chhuikhadan-Gandai Ward 1',
            policeStationPostOffice: 'Khairagarh-Chhuikhadan-Gandai PS / PO',
          ),
        ],
        'Khairagarh-Chhuikhadan-Gandai Block': [
          const VillageRecord(
            villageName: 'Khairagarh-Chhuikhadan-Gandai East',
            lgdCode: '500556',
            gramPanchayat: 'Khairagarh-Chhuikhadan-Gandai East GP',
            policeStationPostOffice: 'Khairagarh-Chhuikhadan-Gandai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khairagarh-Chhuikhadan-Gandai South',
            lgdCode: '500557',
            gramPanchayat: 'Khairagarh-Chhuikhadan-Gandai South GP',
            policeStationPostOffice: 'Khairagarh-Chhuikhadan-Gandai Rural PS',
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
      'Amreli': {

        'Amreli City': [
          const VillageRecord(
            villageName: 'Amreli Rural',
            lgdCode: '500558',
            gramPanchayat: 'Amreli GP',
            policeStationPostOffice: 'Amreli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Amreli North',
            lgdCode: '500559',
            gramPanchayat: 'Amreli Ward 1',
            policeStationPostOffice: 'Amreli PS / PO',
          ),
        ],
        'Amreli Block': [
          const VillageRecord(
            villageName: 'Amreli East',
            lgdCode: '500560',
            gramPanchayat: 'Amreli East GP',
            policeStationPostOffice: 'Amreli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Amreli South',
            lgdCode: '500561',
            gramPanchayat: 'Amreli South GP',
            policeStationPostOffice: 'Amreli Rural PS',
          ),
        ],
      },
      'Anand': {

        'Anand City': [
          const VillageRecord(
            villageName: 'Anand Rural',
            lgdCode: '500562',
            gramPanchayat: 'Anand GP',
            policeStationPostOffice: 'Anand PS / PO',
          ),
          const VillageRecord(
            villageName: 'Anand North',
            lgdCode: '500563',
            gramPanchayat: 'Anand Ward 1',
            policeStationPostOffice: 'Anand PS / PO',
          ),
        ],
        'Anand Block': [
          const VillageRecord(
            villageName: 'Anand East',
            lgdCode: '500564',
            gramPanchayat: 'Anand East GP',
            policeStationPostOffice: 'Anand Rural PS',
          ),
          const VillageRecord(
            villageName: 'Anand South',
            lgdCode: '500565',
            gramPanchayat: 'Anand South GP',
            policeStationPostOffice: 'Anand Rural PS',
          ),
        ],
      },
      'Aravalli': {

        'Aravalli City': [
          const VillageRecord(
            villageName: 'Aravalli Rural',
            lgdCode: '500566',
            gramPanchayat: 'Aravalli GP',
            policeStationPostOffice: 'Aravalli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Aravalli North',
            lgdCode: '500567',
            gramPanchayat: 'Aravalli Ward 1',
            policeStationPostOffice: 'Aravalli PS / PO',
          ),
        ],
        'Aravalli Block': [
          const VillageRecord(
            villageName: 'Aravalli East',
            lgdCode: '500568',
            gramPanchayat: 'Aravalli East GP',
            policeStationPostOffice: 'Aravalli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Aravalli South',
            lgdCode: '500569',
            gramPanchayat: 'Aravalli South GP',
            policeStationPostOffice: 'Aravalli Rural PS',
          ),
        ],
      },
      'Banaskantha': {

        'Banaskantha City': [
          const VillageRecord(
            villageName: 'Banaskantha Rural',
            lgdCode: '500570',
            gramPanchayat: 'Banaskantha GP',
            policeStationPostOffice: 'Banaskantha PS / PO',
          ),
          const VillageRecord(
            villageName: 'Banaskantha North',
            lgdCode: '500571',
            gramPanchayat: 'Banaskantha Ward 1',
            policeStationPostOffice: 'Banaskantha PS / PO',
          ),
        ],
        'Banaskantha Block': [
          const VillageRecord(
            villageName: 'Banaskantha East',
            lgdCode: '500572',
            gramPanchayat: 'Banaskantha East GP',
            policeStationPostOffice: 'Banaskantha Rural PS',
          ),
          const VillageRecord(
            villageName: 'Banaskantha South',
            lgdCode: '500573',
            gramPanchayat: 'Banaskantha South GP',
            policeStationPostOffice: 'Banaskantha Rural PS',
          ),
        ],
      },
      'Bharuch': {

        'Bharuch City': [
          const VillageRecord(
            villageName: 'Bharuch Rural',
            lgdCode: '500574',
            gramPanchayat: 'Bharuch GP',
            policeStationPostOffice: 'Bharuch PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bharuch North',
            lgdCode: '500575',
            gramPanchayat: 'Bharuch Ward 1',
            policeStationPostOffice: 'Bharuch PS / PO',
          ),
        ],
        'Bharuch Block': [
          const VillageRecord(
            villageName: 'Bharuch East',
            lgdCode: '500576',
            gramPanchayat: 'Bharuch East GP',
            policeStationPostOffice: 'Bharuch Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bharuch South',
            lgdCode: '500577',
            gramPanchayat: 'Bharuch South GP',
            policeStationPostOffice: 'Bharuch Rural PS',
          ),
        ],
      },
      'Bhavnagar': {

        'Bhavnagar City': [
          const VillageRecord(
            villageName: 'Bhavnagar Rural',
            lgdCode: '500578',
            gramPanchayat: 'Bhavnagar GP',
            policeStationPostOffice: 'Bhavnagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhavnagar North',
            lgdCode: '500579',
            gramPanchayat: 'Bhavnagar Ward 1',
            policeStationPostOffice: 'Bhavnagar PS / PO',
          ),
        ],
        'Bhavnagar Block': [
          const VillageRecord(
            villageName: 'Bhavnagar East',
            lgdCode: '500580',
            gramPanchayat: 'Bhavnagar East GP',
            policeStationPostOffice: 'Bhavnagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhavnagar South',
            lgdCode: '500581',
            gramPanchayat: 'Bhavnagar South GP',
            policeStationPostOffice: 'Bhavnagar Rural PS',
          ),
        ],
      },
      'Botad': {

        'Botad City': [
          const VillageRecord(
            villageName: 'Botad Rural',
            lgdCode: '500582',
            gramPanchayat: 'Botad GP',
            policeStationPostOffice: 'Botad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Botad North',
            lgdCode: '500583',
            gramPanchayat: 'Botad Ward 1',
            policeStationPostOffice: 'Botad PS / PO',
          ),
        ],
        'Botad Block': [
          const VillageRecord(
            villageName: 'Botad East',
            lgdCode: '500584',
            gramPanchayat: 'Botad East GP',
            policeStationPostOffice: 'Botad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Botad South',
            lgdCode: '500585',
            gramPanchayat: 'Botad South GP',
            policeStationPostOffice: 'Botad Rural PS',
          ),
        ],
      },
      'Chhota Udaipur': {

        'Chhota Udaipur City': [
          const VillageRecord(
            villageName: 'Chhota Udaipur Rural',
            lgdCode: '500586',
            gramPanchayat: 'Chhota Udaipur GP',
            policeStationPostOffice: 'Chhota Udaipur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chhota Udaipur North',
            lgdCode: '500587',
            gramPanchayat: 'Chhota Udaipur Ward 1',
            policeStationPostOffice: 'Chhota Udaipur PS / PO',
          ),
        ],
        'Chhota Udaipur Block': [
          const VillageRecord(
            villageName: 'Chhota Udaipur East',
            lgdCode: '500588',
            gramPanchayat: 'Chhota Udaipur East GP',
            policeStationPostOffice: 'Chhota Udaipur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chhota Udaipur South',
            lgdCode: '500589',
            gramPanchayat: 'Chhota Udaipur South GP',
            policeStationPostOffice: 'Chhota Udaipur Rural PS',
          ),
        ],
      },
      'Dahod': {

        'Dahod City': [
          const VillageRecord(
            villageName: 'Dahod Rural',
            lgdCode: '500590',
            gramPanchayat: 'Dahod GP',
            policeStationPostOffice: 'Dahod PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dahod North',
            lgdCode: '500591',
            gramPanchayat: 'Dahod Ward 1',
            policeStationPostOffice: 'Dahod PS / PO',
          ),
        ],
        'Dahod Block': [
          const VillageRecord(
            villageName: 'Dahod East',
            lgdCode: '500592',
            gramPanchayat: 'Dahod East GP',
            policeStationPostOffice: 'Dahod Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dahod South',
            lgdCode: '500593',
            gramPanchayat: 'Dahod South GP',
            policeStationPostOffice: 'Dahod Rural PS',
          ),
        ],
      },
      'Dang': {

        'Dang City': [
          const VillageRecord(
            villageName: 'Dang Rural',
            lgdCode: '500594',
            gramPanchayat: 'Dang GP',
            policeStationPostOffice: 'Dang PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dang North',
            lgdCode: '500595',
            gramPanchayat: 'Dang Ward 1',
            policeStationPostOffice: 'Dang PS / PO',
          ),
        ],
        'Dang Block': [
          const VillageRecord(
            villageName: 'Dang East',
            lgdCode: '500596',
            gramPanchayat: 'Dang East GP',
            policeStationPostOffice: 'Dang Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dang South',
            lgdCode: '500597',
            gramPanchayat: 'Dang South GP',
            policeStationPostOffice: 'Dang Rural PS',
          ),
        ],
      },
      'Devbhumi Dwarka': {

        'Devbhumi Dwarka City': [
          const VillageRecord(
            villageName: 'Devbhumi Dwarka Rural',
            lgdCode: '500598',
            gramPanchayat: 'Devbhumi Dwarka GP',
            policeStationPostOffice: 'Devbhumi Dwarka PS / PO',
          ),
          const VillageRecord(
            villageName: 'Devbhumi Dwarka North',
            lgdCode: '500599',
            gramPanchayat: 'Devbhumi Dwarka Ward 1',
            policeStationPostOffice: 'Devbhumi Dwarka PS / PO',
          ),
        ],
        'Devbhumi Dwarka Block': [
          const VillageRecord(
            villageName: 'Devbhumi Dwarka East',
            lgdCode: '500600',
            gramPanchayat: 'Devbhumi Dwarka East GP',
            policeStationPostOffice: 'Devbhumi Dwarka Rural PS',
          ),
          const VillageRecord(
            villageName: 'Devbhumi Dwarka South',
            lgdCode: '500601',
            gramPanchayat: 'Devbhumi Dwarka South GP',
            policeStationPostOffice: 'Devbhumi Dwarka Rural PS',
          ),
        ],
      },
      'Gandhinagar': {

        'Gandhinagar City': [
          const VillageRecord(
            villageName: 'Gandhinagar Rural',
            lgdCode: '500602',
            gramPanchayat: 'Gandhinagar GP',
            policeStationPostOffice: 'Gandhinagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gandhinagar North',
            lgdCode: '500603',
            gramPanchayat: 'Gandhinagar Ward 1',
            policeStationPostOffice: 'Gandhinagar PS / PO',
          ),
        ],
        'Gandhinagar Block': [
          const VillageRecord(
            villageName: 'Gandhinagar East',
            lgdCode: '500604',
            gramPanchayat: 'Gandhinagar East GP',
            policeStationPostOffice: 'Gandhinagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gandhinagar South',
            lgdCode: '500605',
            gramPanchayat: 'Gandhinagar South GP',
            policeStationPostOffice: 'Gandhinagar Rural PS',
          ),
        ],
      },
      'Gir Somnath': {

        'Gir Somnath City': [
          const VillageRecord(
            villageName: 'Gir Somnath Rural',
            lgdCode: '500606',
            gramPanchayat: 'Gir Somnath GP',
            policeStationPostOffice: 'Gir Somnath PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gir Somnath North',
            lgdCode: '500607',
            gramPanchayat: 'Gir Somnath Ward 1',
            policeStationPostOffice: 'Gir Somnath PS / PO',
          ),
        ],
        'Gir Somnath Block': [
          const VillageRecord(
            villageName: 'Gir Somnath East',
            lgdCode: '500608',
            gramPanchayat: 'Gir Somnath East GP',
            policeStationPostOffice: 'Gir Somnath Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gir Somnath South',
            lgdCode: '500609',
            gramPanchayat: 'Gir Somnath South GP',
            policeStationPostOffice: 'Gir Somnath Rural PS',
          ),
        ],
      },
      'Jamnagar': {

        'Jamnagar City': [
          const VillageRecord(
            villageName: 'Jamnagar Rural',
            lgdCode: '500610',
            gramPanchayat: 'Jamnagar GP',
            policeStationPostOffice: 'Jamnagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jamnagar North',
            lgdCode: '500611',
            gramPanchayat: 'Jamnagar Ward 1',
            policeStationPostOffice: 'Jamnagar PS / PO',
          ),
        ],
        'Jamnagar Block': [
          const VillageRecord(
            villageName: 'Jamnagar East',
            lgdCode: '500612',
            gramPanchayat: 'Jamnagar East GP',
            policeStationPostOffice: 'Jamnagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jamnagar South',
            lgdCode: '500613',
            gramPanchayat: 'Jamnagar South GP',
            policeStationPostOffice: 'Jamnagar Rural PS',
          ),
        ],
      },
      'Junagadh': {

        'Junagadh City': [
          const VillageRecord(
            villageName: 'Junagadh Rural',
            lgdCode: '500614',
            gramPanchayat: 'Junagadh GP',
            policeStationPostOffice: 'Junagadh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Junagadh North',
            lgdCode: '500615',
            gramPanchayat: 'Junagadh Ward 1',
            policeStationPostOffice: 'Junagadh PS / PO',
          ),
        ],
        'Junagadh Block': [
          const VillageRecord(
            villageName: 'Junagadh East',
            lgdCode: '500616',
            gramPanchayat: 'Junagadh East GP',
            policeStationPostOffice: 'Junagadh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Junagadh South',
            lgdCode: '500617',
            gramPanchayat: 'Junagadh South GP',
            policeStationPostOffice: 'Junagadh Rural PS',
          ),
        ],
      },
      'Kheda': {

        'Kheda City': [
          const VillageRecord(
            villageName: 'Kheda Rural',
            lgdCode: '500618',
            gramPanchayat: 'Kheda GP',
            policeStationPostOffice: 'Kheda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kheda North',
            lgdCode: '500619',
            gramPanchayat: 'Kheda Ward 1',
            policeStationPostOffice: 'Kheda PS / PO',
          ),
        ],
        'Kheda Block': [
          const VillageRecord(
            villageName: 'Kheda East',
            lgdCode: '500620',
            gramPanchayat: 'Kheda East GP',
            policeStationPostOffice: 'Kheda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kheda South',
            lgdCode: '500621',
            gramPanchayat: 'Kheda South GP',
            policeStationPostOffice: 'Kheda Rural PS',
          ),
        ],
      },
      'Kutch': {

        'Kutch City': [
          const VillageRecord(
            villageName: 'Kutch Rural',
            lgdCode: '500622',
            gramPanchayat: 'Kutch GP',
            policeStationPostOffice: 'Kutch PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kutch North',
            lgdCode: '500623',
            gramPanchayat: 'Kutch Ward 1',
            policeStationPostOffice: 'Kutch PS / PO',
          ),
        ],
        'Kutch Block': [
          const VillageRecord(
            villageName: 'Kutch East',
            lgdCode: '500624',
            gramPanchayat: 'Kutch East GP',
            policeStationPostOffice: 'Kutch Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kutch South',
            lgdCode: '500625',
            gramPanchayat: 'Kutch South GP',
            policeStationPostOffice: 'Kutch Rural PS',
          ),
        ],
      },
      'Mahisagar': {

        'Mahisagar City': [
          const VillageRecord(
            villageName: 'Mahisagar Rural',
            lgdCode: '500626',
            gramPanchayat: 'Mahisagar GP',
            policeStationPostOffice: 'Mahisagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mahisagar North',
            lgdCode: '500627',
            gramPanchayat: 'Mahisagar Ward 1',
            policeStationPostOffice: 'Mahisagar PS / PO',
          ),
        ],
        'Mahisagar Block': [
          const VillageRecord(
            villageName: 'Mahisagar East',
            lgdCode: '500628',
            gramPanchayat: 'Mahisagar East GP',
            policeStationPostOffice: 'Mahisagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mahisagar South',
            lgdCode: '500629',
            gramPanchayat: 'Mahisagar South GP',
            policeStationPostOffice: 'Mahisagar Rural PS',
          ),
        ],
      },
      'Mehsana': {

        'Mehsana City': [
          const VillageRecord(
            villageName: 'Mehsana Rural',
            lgdCode: '500630',
            gramPanchayat: 'Mehsana GP',
            policeStationPostOffice: 'Mehsana PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mehsana North',
            lgdCode: '500631',
            gramPanchayat: 'Mehsana Ward 1',
            policeStationPostOffice: 'Mehsana PS / PO',
          ),
        ],
        'Mehsana Block': [
          const VillageRecord(
            villageName: 'Mehsana East',
            lgdCode: '500632',
            gramPanchayat: 'Mehsana East GP',
            policeStationPostOffice: 'Mehsana Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mehsana South',
            lgdCode: '500633',
            gramPanchayat: 'Mehsana South GP',
            policeStationPostOffice: 'Mehsana Rural PS',
          ),
        ],
      },
      'Morbi': {

        'Morbi City': [
          const VillageRecord(
            villageName: 'Morbi Rural',
            lgdCode: '500634',
            gramPanchayat: 'Morbi GP',
            policeStationPostOffice: 'Morbi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Morbi North',
            lgdCode: '500635',
            gramPanchayat: 'Morbi Ward 1',
            policeStationPostOffice: 'Morbi PS / PO',
          ),
        ],
        'Morbi Block': [
          const VillageRecord(
            villageName: 'Morbi East',
            lgdCode: '500636',
            gramPanchayat: 'Morbi East GP',
            policeStationPostOffice: 'Morbi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Morbi South',
            lgdCode: '500637',
            gramPanchayat: 'Morbi South GP',
            policeStationPostOffice: 'Morbi Rural PS',
          ),
        ],
      },
      'Narmada': {

        'Narmada City': [
          const VillageRecord(
            villageName: 'Narmada Rural',
            lgdCode: '500638',
            gramPanchayat: 'Narmada GP',
            policeStationPostOffice: 'Narmada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Narmada North',
            lgdCode: '500639',
            gramPanchayat: 'Narmada Ward 1',
            policeStationPostOffice: 'Narmada PS / PO',
          ),
        ],
        'Narmada Block': [
          const VillageRecord(
            villageName: 'Narmada East',
            lgdCode: '500640',
            gramPanchayat: 'Narmada East GP',
            policeStationPostOffice: 'Narmada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Narmada South',
            lgdCode: '500641',
            gramPanchayat: 'Narmada South GP',
            policeStationPostOffice: 'Narmada Rural PS',
          ),
        ],
      },
      'Navsari': {

        'Navsari City': [
          const VillageRecord(
            villageName: 'Navsari Rural',
            lgdCode: '500642',
            gramPanchayat: 'Navsari GP',
            policeStationPostOffice: 'Navsari PS / PO',
          ),
          const VillageRecord(
            villageName: 'Navsari North',
            lgdCode: '500643',
            gramPanchayat: 'Navsari Ward 1',
            policeStationPostOffice: 'Navsari PS / PO',
          ),
        ],
        'Navsari Block': [
          const VillageRecord(
            villageName: 'Navsari East',
            lgdCode: '500644',
            gramPanchayat: 'Navsari East GP',
            policeStationPostOffice: 'Navsari Rural PS',
          ),
          const VillageRecord(
            villageName: 'Navsari South',
            lgdCode: '500645',
            gramPanchayat: 'Navsari South GP',
            policeStationPostOffice: 'Navsari Rural PS',
          ),
        ],
      },
      'Panchmahal': {

        'Panchmahal City': [
          const VillageRecord(
            villageName: 'Panchmahal Rural',
            lgdCode: '500646',
            gramPanchayat: 'Panchmahal GP',
            policeStationPostOffice: 'Panchmahal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Panchmahal North',
            lgdCode: '500647',
            gramPanchayat: 'Panchmahal Ward 1',
            policeStationPostOffice: 'Panchmahal PS / PO',
          ),
        ],
        'Panchmahal Block': [
          const VillageRecord(
            villageName: 'Panchmahal East',
            lgdCode: '500648',
            gramPanchayat: 'Panchmahal East GP',
            policeStationPostOffice: 'Panchmahal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Panchmahal South',
            lgdCode: '500649',
            gramPanchayat: 'Panchmahal South GP',
            policeStationPostOffice: 'Panchmahal Rural PS',
          ),
        ],
      },
      'Patan': {

        'Patan City': [
          const VillageRecord(
            villageName: 'Patan Rural',
            lgdCode: '500650',
            gramPanchayat: 'Patan GP',
            policeStationPostOffice: 'Patan PS / PO',
          ),
          const VillageRecord(
            villageName: 'Patan North',
            lgdCode: '500651',
            gramPanchayat: 'Patan Ward 1',
            policeStationPostOffice: 'Patan PS / PO',
          ),
        ],
        'Patan Block': [
          const VillageRecord(
            villageName: 'Patan East',
            lgdCode: '500652',
            gramPanchayat: 'Patan East GP',
            policeStationPostOffice: 'Patan Rural PS',
          ),
          const VillageRecord(
            villageName: 'Patan South',
            lgdCode: '500653',
            gramPanchayat: 'Patan South GP',
            policeStationPostOffice: 'Patan Rural PS',
          ),
        ],
      },
      'Porbandar': {

        'Porbandar City': [
          const VillageRecord(
            villageName: 'Porbandar Rural',
            lgdCode: '500654',
            gramPanchayat: 'Porbandar GP',
            policeStationPostOffice: 'Porbandar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Porbandar North',
            lgdCode: '500655',
            gramPanchayat: 'Porbandar Ward 1',
            policeStationPostOffice: 'Porbandar PS / PO',
          ),
        ],
        'Porbandar Block': [
          const VillageRecord(
            villageName: 'Porbandar East',
            lgdCode: '500656',
            gramPanchayat: 'Porbandar East GP',
            policeStationPostOffice: 'Porbandar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Porbandar South',
            lgdCode: '500657',
            gramPanchayat: 'Porbandar South GP',
            policeStationPostOffice: 'Porbandar Rural PS',
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
      'Sabarkantha': {

        'Sabarkantha City': [
          const VillageRecord(
            villageName: 'Sabarkantha Rural',
            lgdCode: '500658',
            gramPanchayat: 'Sabarkantha GP',
            policeStationPostOffice: 'Sabarkantha PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sabarkantha North',
            lgdCode: '500659',
            gramPanchayat: 'Sabarkantha Ward 1',
            policeStationPostOffice: 'Sabarkantha PS / PO',
          ),
        ],
        'Sabarkantha Block': [
          const VillageRecord(
            villageName: 'Sabarkantha East',
            lgdCode: '500660',
            gramPanchayat: 'Sabarkantha East GP',
            policeStationPostOffice: 'Sabarkantha Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sabarkantha South',
            lgdCode: '500661',
            gramPanchayat: 'Sabarkantha South GP',
            policeStationPostOffice: 'Sabarkantha Rural PS',
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
      'Surendranagar': {

        'Surendranagar City': [
          const VillageRecord(
            villageName: 'Surendranagar Rural',
            lgdCode: '500662',
            gramPanchayat: 'Surendranagar GP',
            policeStationPostOffice: 'Surendranagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Surendranagar North',
            lgdCode: '500663',
            gramPanchayat: 'Surendranagar Ward 1',
            policeStationPostOffice: 'Surendranagar PS / PO',
          ),
        ],
        'Surendranagar Block': [
          const VillageRecord(
            villageName: 'Surendranagar East',
            lgdCode: '500664',
            gramPanchayat: 'Surendranagar East GP',
            policeStationPostOffice: 'Surendranagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Surendranagar South',
            lgdCode: '500665',
            gramPanchayat: 'Surendranagar South GP',
            policeStationPostOffice: 'Surendranagar Rural PS',
          ),
        ],
      },
      'Tapi': {

        'Tapi City': [
          const VillageRecord(
            villageName: 'Tapi Rural',
            lgdCode: '500666',
            gramPanchayat: 'Tapi GP',
            policeStationPostOffice: 'Tapi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tapi North',
            lgdCode: '500667',
            gramPanchayat: 'Tapi Ward 1',
            policeStationPostOffice: 'Tapi PS / PO',
          ),
        ],
        'Tapi Block': [
          const VillageRecord(
            villageName: 'Tapi East',
            lgdCode: '500668',
            gramPanchayat: 'Tapi East GP',
            policeStationPostOffice: 'Tapi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tapi South',
            lgdCode: '500669',
            gramPanchayat: 'Tapi South GP',
            policeStationPostOffice: 'Tapi Rural PS',
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
      'Valsad': {

        'Valsad City': [
          const VillageRecord(
            villageName: 'Valsad Rural',
            lgdCode: '500670',
            gramPanchayat: 'Valsad GP',
            policeStationPostOffice: 'Valsad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Valsad North',
            lgdCode: '500671',
            gramPanchayat: 'Valsad Ward 1',
            policeStationPostOffice: 'Valsad PS / PO',
          ),
        ],
        'Valsad Block': [
          const VillageRecord(
            villageName: 'Valsad East',
            lgdCode: '500672',
            gramPanchayat: 'Valsad East GP',
            policeStationPostOffice: 'Valsad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Valsad South',
            lgdCode: '500673',
            gramPanchayat: 'Valsad South GP',
            policeStationPostOffice: 'Valsad Rural PS',
          ),
        ],
      },
    },
    'Haryana': {
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
      'Bhiwani': {

        'Bhiwani City': [
          const VillageRecord(
            villageName: 'Bhiwani Rural',
            lgdCode: '500674',
            gramPanchayat: 'Bhiwani GP',
            policeStationPostOffice: 'Bhiwani PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhiwani North',
            lgdCode: '500675',
            gramPanchayat: 'Bhiwani Ward 1',
            policeStationPostOffice: 'Bhiwani PS / PO',
          ),
        ],
        'Bhiwani Block': [
          const VillageRecord(
            villageName: 'Bhiwani East',
            lgdCode: '500676',
            gramPanchayat: 'Bhiwani East GP',
            policeStationPostOffice: 'Bhiwani Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhiwani South',
            lgdCode: '500677',
            gramPanchayat: 'Bhiwani South GP',
            policeStationPostOffice: 'Bhiwani Rural PS',
          ),
        ],
      },
      'Charkhi Dadri': {

        'Charkhi Dadri City': [
          const VillageRecord(
            villageName: 'Charkhi Dadri Rural',
            lgdCode: '500678',
            gramPanchayat: 'Charkhi Dadri GP',
            policeStationPostOffice: 'Charkhi Dadri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Charkhi Dadri North',
            lgdCode: '500679',
            gramPanchayat: 'Charkhi Dadri Ward 1',
            policeStationPostOffice: 'Charkhi Dadri PS / PO',
          ),
        ],
        'Charkhi Dadri Block': [
          const VillageRecord(
            villageName: 'Charkhi Dadri East',
            lgdCode: '500680',
            gramPanchayat: 'Charkhi Dadri East GP',
            policeStationPostOffice: 'Charkhi Dadri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Charkhi Dadri South',
            lgdCode: '500681',
            gramPanchayat: 'Charkhi Dadri South GP',
            policeStationPostOffice: 'Charkhi Dadri Rural PS',
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
      'Fatehabad': {

        'Fatehabad City': [
          const VillageRecord(
            villageName: 'Fatehabad Rural',
            lgdCode: '500682',
            gramPanchayat: 'Fatehabad GP',
            policeStationPostOffice: 'Fatehabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Fatehabad North',
            lgdCode: '500683',
            gramPanchayat: 'Fatehabad Ward 1',
            policeStationPostOffice: 'Fatehabad PS / PO',
          ),
        ],
        'Fatehabad Block': [
          const VillageRecord(
            villageName: 'Fatehabad East',
            lgdCode: '500684',
            gramPanchayat: 'Fatehabad East GP',
            policeStationPostOffice: 'Fatehabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Fatehabad South',
            lgdCode: '500685',
            gramPanchayat: 'Fatehabad South GP',
            policeStationPostOffice: 'Fatehabad Rural PS',
          ),
        ],
      },
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
      'Jhajjar': {

        'Jhajjar City': [
          const VillageRecord(
            villageName: 'Jhajjar Rural',
            lgdCode: '500686',
            gramPanchayat: 'Jhajjar GP',
            policeStationPostOffice: 'Jhajjar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jhajjar North',
            lgdCode: '500687',
            gramPanchayat: 'Jhajjar Ward 1',
            policeStationPostOffice: 'Jhajjar PS / PO',
          ),
        ],
        'Jhajjar Block': [
          const VillageRecord(
            villageName: 'Jhajjar East',
            lgdCode: '500688',
            gramPanchayat: 'Jhajjar East GP',
            policeStationPostOffice: 'Jhajjar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jhajjar South',
            lgdCode: '500689',
            gramPanchayat: 'Jhajjar South GP',
            policeStationPostOffice: 'Jhajjar Rural PS',
          ),
        ],
      },
      'Jind': {

        'Jind City': [
          const VillageRecord(
            villageName: 'Jind Rural',
            lgdCode: '500690',
            gramPanchayat: 'Jind GP',
            policeStationPostOffice: 'Jind PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jind North',
            lgdCode: '500691',
            gramPanchayat: 'Jind Ward 1',
            policeStationPostOffice: 'Jind PS / PO',
          ),
        ],
        'Jind Block': [
          const VillageRecord(
            villageName: 'Jind East',
            lgdCode: '500692',
            gramPanchayat: 'Jind East GP',
            policeStationPostOffice: 'Jind Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jind South',
            lgdCode: '500693',
            gramPanchayat: 'Jind South GP',
            policeStationPostOffice: 'Jind Rural PS',
          ),
        ],
      },
      'Kaithal': {

        'Kaithal City': [
          const VillageRecord(
            villageName: 'Kaithal Rural',
            lgdCode: '500694',
            gramPanchayat: 'Kaithal GP',
            policeStationPostOffice: 'Kaithal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kaithal North',
            lgdCode: '500695',
            gramPanchayat: 'Kaithal Ward 1',
            policeStationPostOffice: 'Kaithal PS / PO',
          ),
        ],
        'Kaithal Block': [
          const VillageRecord(
            villageName: 'Kaithal East',
            lgdCode: '500696',
            gramPanchayat: 'Kaithal East GP',
            policeStationPostOffice: 'Kaithal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kaithal South',
            lgdCode: '500697',
            gramPanchayat: 'Kaithal South GP',
            policeStationPostOffice: 'Kaithal Rural PS',
          ),
        ],
      },
      'Karnal': {

        'Karnal City': [
          const VillageRecord(
            villageName: 'Karnal Rural',
            lgdCode: '500698',
            gramPanchayat: 'Karnal GP',
            policeStationPostOffice: 'Karnal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Karnal North',
            lgdCode: '500699',
            gramPanchayat: 'Karnal Ward 1',
            policeStationPostOffice: 'Karnal PS / PO',
          ),
        ],
        'Karnal Block': [
          const VillageRecord(
            villageName: 'Karnal East',
            lgdCode: '500700',
            gramPanchayat: 'Karnal East GP',
            policeStationPostOffice: 'Karnal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Karnal South',
            lgdCode: '500701',
            gramPanchayat: 'Karnal South GP',
            policeStationPostOffice: 'Karnal Rural PS',
          ),
        ],
      },
      'Kurukshetra': {

        'Kurukshetra City': [
          const VillageRecord(
            villageName: 'Kurukshetra Rural',
            lgdCode: '500702',
            gramPanchayat: 'Kurukshetra GP',
            policeStationPostOffice: 'Kurukshetra PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kurukshetra North',
            lgdCode: '500703',
            gramPanchayat: 'Kurukshetra Ward 1',
            policeStationPostOffice: 'Kurukshetra PS / PO',
          ),
        ],
        'Kurukshetra Block': [
          const VillageRecord(
            villageName: 'Kurukshetra East',
            lgdCode: '500704',
            gramPanchayat: 'Kurukshetra East GP',
            policeStationPostOffice: 'Kurukshetra Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kurukshetra South',
            lgdCode: '500705',
            gramPanchayat: 'Kurukshetra South GP',
            policeStationPostOffice: 'Kurukshetra Rural PS',
          ),
        ],
      },
      'Mahendragarh': {

        'Mahendragarh City': [
          const VillageRecord(
            villageName: 'Mahendragarh Rural',
            lgdCode: '500706',
            gramPanchayat: 'Mahendragarh GP',
            policeStationPostOffice: 'Mahendragarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mahendragarh North',
            lgdCode: '500707',
            gramPanchayat: 'Mahendragarh Ward 1',
            policeStationPostOffice: 'Mahendragarh PS / PO',
          ),
        ],
        'Mahendragarh Block': [
          const VillageRecord(
            villageName: 'Mahendragarh East',
            lgdCode: '500708',
            gramPanchayat: 'Mahendragarh East GP',
            policeStationPostOffice: 'Mahendragarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mahendragarh South',
            lgdCode: '500709',
            gramPanchayat: 'Mahendragarh South GP',
            policeStationPostOffice: 'Mahendragarh Rural PS',
          ),
        ],
      },
      'Nuh': {

        'Nuh City': [
          const VillageRecord(
            villageName: 'Nuh Rural',
            lgdCode: '500710',
            gramPanchayat: 'Nuh GP',
            policeStationPostOffice: 'Nuh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nuh North',
            lgdCode: '500711',
            gramPanchayat: 'Nuh Ward 1',
            policeStationPostOffice: 'Nuh PS / PO',
          ),
        ],
        'Nuh Block': [
          const VillageRecord(
            villageName: 'Nuh East',
            lgdCode: '500712',
            gramPanchayat: 'Nuh East GP',
            policeStationPostOffice: 'Nuh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nuh South',
            lgdCode: '500713',
            gramPanchayat: 'Nuh South GP',
            policeStationPostOffice: 'Nuh Rural PS',
          ),
        ],
      },
      'Palwal': {

        'Palwal City': [
          const VillageRecord(
            villageName: 'Palwal Rural',
            lgdCode: '500714',
            gramPanchayat: 'Palwal GP',
            policeStationPostOffice: 'Palwal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Palwal North',
            lgdCode: '500715',
            gramPanchayat: 'Palwal Ward 1',
            policeStationPostOffice: 'Palwal PS / PO',
          ),
        ],
        'Palwal Block': [
          const VillageRecord(
            villageName: 'Palwal East',
            lgdCode: '500716',
            gramPanchayat: 'Palwal East GP',
            policeStationPostOffice: 'Palwal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Palwal South',
            lgdCode: '500717',
            gramPanchayat: 'Palwal South GP',
            policeStationPostOffice: 'Palwal Rural PS',
          ),
        ],
      },
      'Panchkula': {

        'Panchkula City': [
          const VillageRecord(
            villageName: 'Panchkula Rural',
            lgdCode: '500718',
            gramPanchayat: 'Panchkula GP',
            policeStationPostOffice: 'Panchkula PS / PO',
          ),
          const VillageRecord(
            villageName: 'Panchkula North',
            lgdCode: '500719',
            gramPanchayat: 'Panchkula Ward 1',
            policeStationPostOffice: 'Panchkula PS / PO',
          ),
        ],
        'Panchkula Block': [
          const VillageRecord(
            villageName: 'Panchkula East',
            lgdCode: '500720',
            gramPanchayat: 'Panchkula East GP',
            policeStationPostOffice: 'Panchkula Rural PS',
          ),
          const VillageRecord(
            villageName: 'Panchkula South',
            lgdCode: '500721',
            gramPanchayat: 'Panchkula South GP',
            policeStationPostOffice: 'Panchkula Rural PS',
          ),
        ],
      },
      'Panipat': {

        'Panipat City': [
          const VillageRecord(
            villageName: 'Panipat Rural',
            lgdCode: '500722',
            gramPanchayat: 'Panipat GP',
            policeStationPostOffice: 'Panipat PS / PO',
          ),
          const VillageRecord(
            villageName: 'Panipat North',
            lgdCode: '500723',
            gramPanchayat: 'Panipat Ward 1',
            policeStationPostOffice: 'Panipat PS / PO',
          ),
        ],
        'Panipat Block': [
          const VillageRecord(
            villageName: 'Panipat East',
            lgdCode: '500724',
            gramPanchayat: 'Panipat East GP',
            policeStationPostOffice: 'Panipat Rural PS',
          ),
          const VillageRecord(
            villageName: 'Panipat South',
            lgdCode: '500725',
            gramPanchayat: 'Panipat South GP',
            policeStationPostOffice: 'Panipat Rural PS',
          ),
        ],
      },
      'Rewari': {

        'Rewari City': [
          const VillageRecord(
            villageName: 'Rewari Rural',
            lgdCode: '500726',
            gramPanchayat: 'Rewari GP',
            policeStationPostOffice: 'Rewari PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rewari North',
            lgdCode: '500727',
            gramPanchayat: 'Rewari Ward 1',
            policeStationPostOffice: 'Rewari PS / PO',
          ),
        ],
        'Rewari Block': [
          const VillageRecord(
            villageName: 'Rewari East',
            lgdCode: '500728',
            gramPanchayat: 'Rewari East GP',
            policeStationPostOffice: 'Rewari Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rewari South',
            lgdCode: '500729',
            gramPanchayat: 'Rewari South GP',
            policeStationPostOffice: 'Rewari Rural PS',
          ),
        ],
      },
      'Rohtak': {

        'Rohtak City': [
          const VillageRecord(
            villageName: 'Rohtak Rural',
            lgdCode: '500730',
            gramPanchayat: 'Rohtak GP',
            policeStationPostOffice: 'Rohtak PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rohtak North',
            lgdCode: '500731',
            gramPanchayat: 'Rohtak Ward 1',
            policeStationPostOffice: 'Rohtak PS / PO',
          ),
        ],
        'Rohtak Block': [
          const VillageRecord(
            villageName: 'Rohtak East',
            lgdCode: '500732',
            gramPanchayat: 'Rohtak East GP',
            policeStationPostOffice: 'Rohtak Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rohtak South',
            lgdCode: '500733',
            gramPanchayat: 'Rohtak South GP',
            policeStationPostOffice: 'Rohtak Rural PS',
          ),
        ],
      },
      'Sirsa': {

        'Sirsa City': [
          const VillageRecord(
            villageName: 'Sirsa Rural',
            lgdCode: '500734',
            gramPanchayat: 'Sirsa GP',
            policeStationPostOffice: 'Sirsa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sirsa North',
            lgdCode: '500735',
            gramPanchayat: 'Sirsa Ward 1',
            policeStationPostOffice: 'Sirsa PS / PO',
          ),
        ],
        'Sirsa Block': [
          const VillageRecord(
            villageName: 'Sirsa East',
            lgdCode: '500736',
            gramPanchayat: 'Sirsa East GP',
            policeStationPostOffice: 'Sirsa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sirsa South',
            lgdCode: '500737',
            gramPanchayat: 'Sirsa South GP',
            policeStationPostOffice: 'Sirsa Rural PS',
          ),
        ],
      },
      'Sonipat': {

        'Sonipat City': [
          const VillageRecord(
            villageName: 'Sonipat Rural',
            lgdCode: '500738',
            gramPanchayat: 'Sonipat GP',
            policeStationPostOffice: 'Sonipat PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sonipat North',
            lgdCode: '500739',
            gramPanchayat: 'Sonipat Ward 1',
            policeStationPostOffice: 'Sonipat PS / PO',
          ),
        ],
        'Sonipat Block': [
          const VillageRecord(
            villageName: 'Sonipat East',
            lgdCode: '500740',
            gramPanchayat: 'Sonipat East GP',
            policeStationPostOffice: 'Sonipat Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sonipat South',
            lgdCode: '500741',
            gramPanchayat: 'Sonipat South GP',
            policeStationPostOffice: 'Sonipat Rural PS',
          ),
        ],
      },
      'Yamunanagar': {

        'Yamunanagar City': [
          const VillageRecord(
            villageName: 'Yamunanagar Rural',
            lgdCode: '500742',
            gramPanchayat: 'Yamunanagar GP',
            policeStationPostOffice: 'Yamunanagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Yamunanagar North',
            lgdCode: '500743',
            gramPanchayat: 'Yamunanagar Ward 1',
            policeStationPostOffice: 'Yamunanagar PS / PO',
          ),
        ],
        'Yamunanagar Block': [
          const VillageRecord(
            villageName: 'Yamunanagar East',
            lgdCode: '500744',
            gramPanchayat: 'Yamunanagar East GP',
            policeStationPostOffice: 'Yamunanagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Yamunanagar South',
            lgdCode: '500745',
            gramPanchayat: 'Yamunanagar South GP',
            policeStationPostOffice: 'Yamunanagar Rural PS',
          ),
        ],
      },
    },
    'Himachal Pradesh': {
      'Bilaspur': {

        'Bilaspur City': [
          const VillageRecord(
            villageName: 'Bilaspur Rural',
            lgdCode: '500746',
            gramPanchayat: 'Bilaspur GP',
            policeStationPostOffice: 'Bilaspur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bilaspur North',
            lgdCode: '500747',
            gramPanchayat: 'Bilaspur Ward 1',
            policeStationPostOffice: 'Bilaspur PS / PO',
          ),
        ],
        'Bilaspur Block': [
          const VillageRecord(
            villageName: 'Bilaspur East',
            lgdCode: '500748',
            gramPanchayat: 'Bilaspur East GP',
            policeStationPostOffice: 'Bilaspur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bilaspur South',
            lgdCode: '500749',
            gramPanchayat: 'Bilaspur South GP',
            policeStationPostOffice: 'Bilaspur Rural PS',
          ),
        ],
      },
      'Chamba': {

        'Chamba City': [
          const VillageRecord(
            villageName: 'Chamba Rural',
            lgdCode: '500750',
            gramPanchayat: 'Chamba GP',
            policeStationPostOffice: 'Chamba PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chamba North',
            lgdCode: '500751',
            gramPanchayat: 'Chamba Ward 1',
            policeStationPostOffice: 'Chamba PS / PO',
          ),
        ],
        'Chamba Block': [
          const VillageRecord(
            villageName: 'Chamba East',
            lgdCode: '500752',
            gramPanchayat: 'Chamba East GP',
            policeStationPostOffice: 'Chamba Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chamba South',
            lgdCode: '500753',
            gramPanchayat: 'Chamba South GP',
            policeStationPostOffice: 'Chamba Rural PS',
          ),
        ],
      },
      'Hamirpur': {

        'Hamirpur City': [
          const VillageRecord(
            villageName: 'Hamirpur Rural',
            lgdCode: '500754',
            gramPanchayat: 'Hamirpur GP',
            policeStationPostOffice: 'Hamirpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hamirpur North',
            lgdCode: '500755',
            gramPanchayat: 'Hamirpur Ward 1',
            policeStationPostOffice: 'Hamirpur PS / PO',
          ),
        ],
        'Hamirpur Block': [
          const VillageRecord(
            villageName: 'Hamirpur East',
            lgdCode: '500756',
            gramPanchayat: 'Hamirpur East GP',
            policeStationPostOffice: 'Hamirpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hamirpur South',
            lgdCode: '500757',
            gramPanchayat: 'Hamirpur South GP',
            policeStationPostOffice: 'Hamirpur Rural PS',
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
      'Kinnaur': {

        'Kinnaur City': [
          const VillageRecord(
            villageName: 'Kinnaur Rural',
            lgdCode: '500758',
            gramPanchayat: 'Kinnaur GP',
            policeStationPostOffice: 'Kinnaur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kinnaur North',
            lgdCode: '500759',
            gramPanchayat: 'Kinnaur Ward 1',
            policeStationPostOffice: 'Kinnaur PS / PO',
          ),
        ],
        'Kinnaur Block': [
          const VillageRecord(
            villageName: 'Kinnaur East',
            lgdCode: '500760',
            gramPanchayat: 'Kinnaur East GP',
            policeStationPostOffice: 'Kinnaur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kinnaur South',
            lgdCode: '500761',
            gramPanchayat: 'Kinnaur South GP',
            policeStationPostOffice: 'Kinnaur Rural PS',
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
      'Lahaul and Spiti': {

        'Lahaul and Spiti City': [
          const VillageRecord(
            villageName: 'Lahaul and Spiti Rural',
            lgdCode: '500762',
            gramPanchayat: 'Lahaul and Spiti GP',
            policeStationPostOffice: 'Lahaul and Spiti PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lahaul and Spiti North',
            lgdCode: '500763',
            gramPanchayat: 'Lahaul and Spiti Ward 1',
            policeStationPostOffice: 'Lahaul and Spiti PS / PO',
          ),
        ],
        'Lahaul and Spiti Block': [
          const VillageRecord(
            villageName: 'Lahaul and Spiti East',
            lgdCode: '500764',
            gramPanchayat: 'Lahaul and Spiti East GP',
            policeStationPostOffice: 'Lahaul and Spiti Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lahaul and Spiti South',
            lgdCode: '500765',
            gramPanchayat: 'Lahaul and Spiti South GP',
            policeStationPostOffice: 'Lahaul and Spiti Rural PS',
          ),
        ],
      },
      'Mandi': {

        'Mandi City': [
          const VillageRecord(
            villageName: 'Mandi Rural',
            lgdCode: '500766',
            gramPanchayat: 'Mandi GP',
            policeStationPostOffice: 'Mandi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mandi North',
            lgdCode: '500767',
            gramPanchayat: 'Mandi Ward 1',
            policeStationPostOffice: 'Mandi PS / PO',
          ),
        ],
        'Mandi Block': [
          const VillageRecord(
            villageName: 'Mandi East',
            lgdCode: '500768',
            gramPanchayat: 'Mandi East GP',
            policeStationPostOffice: 'Mandi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mandi South',
            lgdCode: '500769',
            gramPanchayat: 'Mandi South GP',
            policeStationPostOffice: 'Mandi Rural PS',
          ),
        ],
      },
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
      'Sirmaur': {

        'Sirmaur City': [
          const VillageRecord(
            villageName: 'Sirmaur Rural',
            lgdCode: '500770',
            gramPanchayat: 'Sirmaur GP',
            policeStationPostOffice: 'Sirmaur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sirmaur North',
            lgdCode: '500771',
            gramPanchayat: 'Sirmaur Ward 1',
            policeStationPostOffice: 'Sirmaur PS / PO',
          ),
        ],
        'Sirmaur Block': [
          const VillageRecord(
            villageName: 'Sirmaur East',
            lgdCode: '500772',
            gramPanchayat: 'Sirmaur East GP',
            policeStationPostOffice: 'Sirmaur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sirmaur South',
            lgdCode: '500773',
            gramPanchayat: 'Sirmaur South GP',
            policeStationPostOffice: 'Sirmaur Rural PS',
          ),
        ],
      },
      'Solan': {

        'Solan City': [
          const VillageRecord(
            villageName: 'Solan Rural',
            lgdCode: '500774',
            gramPanchayat: 'Solan GP',
            policeStationPostOffice: 'Solan PS / PO',
          ),
          const VillageRecord(
            villageName: 'Solan North',
            lgdCode: '500775',
            gramPanchayat: 'Solan Ward 1',
            policeStationPostOffice: 'Solan PS / PO',
          ),
        ],
        'Solan Block': [
          const VillageRecord(
            villageName: 'Solan East',
            lgdCode: '500776',
            gramPanchayat: 'Solan East GP',
            policeStationPostOffice: 'Solan Rural PS',
          ),
          const VillageRecord(
            villageName: 'Solan South',
            lgdCode: '500777',
            gramPanchayat: 'Solan South GP',
            policeStationPostOffice: 'Solan Rural PS',
          ),
        ],
      },
      'Una': {

        'Una City': [
          const VillageRecord(
            villageName: 'Una Rural',
            lgdCode: '500778',
            gramPanchayat: 'Una GP',
            policeStationPostOffice: 'Una PS / PO',
          ),
          const VillageRecord(
            villageName: 'Una North',
            lgdCode: '500779',
            gramPanchayat: 'Una Ward 1',
            policeStationPostOffice: 'Una PS / PO',
          ),
        ],
        'Una Block': [
          const VillageRecord(
            villageName: 'Una East',
            lgdCode: '500780',
            gramPanchayat: 'Una East GP',
            policeStationPostOffice: 'Una Rural PS',
          ),
          const VillageRecord(
            villageName: 'Una South',
            lgdCode: '500781',
            gramPanchayat: 'Una South GP',
            policeStationPostOffice: 'Una Rural PS',
          ),
        ],
      },
    },
    'Jharkhand': {
      'Bokaro': {

        'Bokaro City': [
          const VillageRecord(
            villageName: 'Bokaro Rural',
            lgdCode: '500782',
            gramPanchayat: 'Bokaro GP',
            policeStationPostOffice: 'Bokaro PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bokaro North',
            lgdCode: '500783',
            gramPanchayat: 'Bokaro Ward 1',
            policeStationPostOffice: 'Bokaro PS / PO',
          ),
        ],
        'Bokaro Block': [
          const VillageRecord(
            villageName: 'Bokaro East',
            lgdCode: '500784',
            gramPanchayat: 'Bokaro East GP',
            policeStationPostOffice: 'Bokaro Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bokaro South',
            lgdCode: '500785',
            gramPanchayat: 'Bokaro South GP',
            policeStationPostOffice: 'Bokaro Rural PS',
          ),
        ],
      },
      'Chatra': {

        'Chatra City': [
          const VillageRecord(
            villageName: 'Chatra Rural',
            lgdCode: '500786',
            gramPanchayat: 'Chatra GP',
            policeStationPostOffice: 'Chatra PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chatra North',
            lgdCode: '500787',
            gramPanchayat: 'Chatra Ward 1',
            policeStationPostOffice: 'Chatra PS / PO',
          ),
        ],
        'Chatra Block': [
          const VillageRecord(
            villageName: 'Chatra East',
            lgdCode: '500788',
            gramPanchayat: 'Chatra East GP',
            policeStationPostOffice: 'Chatra Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chatra South',
            lgdCode: '500789',
            gramPanchayat: 'Chatra South GP',
            policeStationPostOffice: 'Chatra Rural PS',
          ),
        ],
      },
      'Deoghar': {

        'Deoghar City': [
          const VillageRecord(
            villageName: 'Deoghar Rural',
            lgdCode: '500790',
            gramPanchayat: 'Deoghar GP',
            policeStationPostOffice: 'Deoghar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Deoghar North',
            lgdCode: '500791',
            gramPanchayat: 'Deoghar Ward 1',
            policeStationPostOffice: 'Deoghar PS / PO',
          ),
        ],
        'Deoghar Block': [
          const VillageRecord(
            villageName: 'Deoghar East',
            lgdCode: '500792',
            gramPanchayat: 'Deoghar East GP',
            policeStationPostOffice: 'Deoghar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Deoghar South',
            lgdCode: '500793',
            gramPanchayat: 'Deoghar South GP',
            policeStationPostOffice: 'Deoghar Rural PS',
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
      'Dumka': {

        'Dumka City': [
          const VillageRecord(
            villageName: 'Dumka Rural',
            lgdCode: '500794',
            gramPanchayat: 'Dumka GP',
            policeStationPostOffice: 'Dumka PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dumka North',
            lgdCode: '500795',
            gramPanchayat: 'Dumka Ward 1',
            policeStationPostOffice: 'Dumka PS / PO',
          ),
        ],
        'Dumka Block': [
          const VillageRecord(
            villageName: 'Dumka East',
            lgdCode: '500796',
            gramPanchayat: 'Dumka East GP',
            policeStationPostOffice: 'Dumka Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dumka South',
            lgdCode: '500797',
            gramPanchayat: 'Dumka South GP',
            policeStationPostOffice: 'Dumka Rural PS',
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
      'Garhwa': {

        'Garhwa City': [
          const VillageRecord(
            villageName: 'Garhwa Rural',
            lgdCode: '500798',
            gramPanchayat: 'Garhwa GP',
            policeStationPostOffice: 'Garhwa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Garhwa North',
            lgdCode: '500799',
            gramPanchayat: 'Garhwa Ward 1',
            policeStationPostOffice: 'Garhwa PS / PO',
          ),
        ],
        'Garhwa Block': [
          const VillageRecord(
            villageName: 'Garhwa East',
            lgdCode: '500800',
            gramPanchayat: 'Garhwa East GP',
            policeStationPostOffice: 'Garhwa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Garhwa South',
            lgdCode: '500801',
            gramPanchayat: 'Garhwa South GP',
            policeStationPostOffice: 'Garhwa Rural PS',
          ),
        ],
      },
      'Giridih': {

        'Giridih City': [
          const VillageRecord(
            villageName: 'Giridih Rural',
            lgdCode: '500802',
            gramPanchayat: 'Giridih GP',
            policeStationPostOffice: 'Giridih PS / PO',
          ),
          const VillageRecord(
            villageName: 'Giridih North',
            lgdCode: '500803',
            gramPanchayat: 'Giridih Ward 1',
            policeStationPostOffice: 'Giridih PS / PO',
          ),
        ],
        'Giridih Block': [
          const VillageRecord(
            villageName: 'Giridih East',
            lgdCode: '500804',
            gramPanchayat: 'Giridih East GP',
            policeStationPostOffice: 'Giridih Rural PS',
          ),
          const VillageRecord(
            villageName: 'Giridih South',
            lgdCode: '500805',
            gramPanchayat: 'Giridih South GP',
            policeStationPostOffice: 'Giridih Rural PS',
          ),
        ],
      },
      'Godda': {

        'Godda City': [
          const VillageRecord(
            villageName: 'Godda Rural',
            lgdCode: '500806',
            gramPanchayat: 'Godda GP',
            policeStationPostOffice: 'Godda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Godda North',
            lgdCode: '500807',
            gramPanchayat: 'Godda Ward 1',
            policeStationPostOffice: 'Godda PS / PO',
          ),
        ],
        'Godda Block': [
          const VillageRecord(
            villageName: 'Godda East',
            lgdCode: '500808',
            gramPanchayat: 'Godda East GP',
            policeStationPostOffice: 'Godda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Godda South',
            lgdCode: '500809',
            gramPanchayat: 'Godda South GP',
            policeStationPostOffice: 'Godda Rural PS',
          ),
        ],
      },
      'Gumla': {

        'Gumla City': [
          const VillageRecord(
            villageName: 'Gumla Rural',
            lgdCode: '500810',
            gramPanchayat: 'Gumla GP',
            policeStationPostOffice: 'Gumla PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gumla North',
            lgdCode: '500811',
            gramPanchayat: 'Gumla Ward 1',
            policeStationPostOffice: 'Gumla PS / PO',
          ),
        ],
        'Gumla Block': [
          const VillageRecord(
            villageName: 'Gumla East',
            lgdCode: '500812',
            gramPanchayat: 'Gumla East GP',
            policeStationPostOffice: 'Gumla Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gumla South',
            lgdCode: '500813',
            gramPanchayat: 'Gumla South GP',
            policeStationPostOffice: 'Gumla Rural PS',
          ),
        ],
      },
      'Hazaribagh': {

        'Hazaribagh City': [
          const VillageRecord(
            villageName: 'Hazaribagh Rural',
            lgdCode: '500814',
            gramPanchayat: 'Hazaribagh GP',
            policeStationPostOffice: 'Hazaribagh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hazaribagh North',
            lgdCode: '500815',
            gramPanchayat: 'Hazaribagh Ward 1',
            policeStationPostOffice: 'Hazaribagh PS / PO',
          ),
        ],
        'Hazaribagh Block': [
          const VillageRecord(
            villageName: 'Hazaribagh East',
            lgdCode: '500816',
            gramPanchayat: 'Hazaribagh East GP',
            policeStationPostOffice: 'Hazaribagh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hazaribagh South',
            lgdCode: '500817',
            gramPanchayat: 'Hazaribagh South GP',
            policeStationPostOffice: 'Hazaribagh Rural PS',
          ),
        ],
      },
      'Jamtara': {

        'Jamtara City': [
          const VillageRecord(
            villageName: 'Jamtara Rural',
            lgdCode: '500818',
            gramPanchayat: 'Jamtara GP',
            policeStationPostOffice: 'Jamtara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jamtara North',
            lgdCode: '500819',
            gramPanchayat: 'Jamtara Ward 1',
            policeStationPostOffice: 'Jamtara PS / PO',
          ),
        ],
        'Jamtara Block': [
          const VillageRecord(
            villageName: 'Jamtara East',
            lgdCode: '500820',
            gramPanchayat: 'Jamtara East GP',
            policeStationPostOffice: 'Jamtara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jamtara South',
            lgdCode: '500821',
            gramPanchayat: 'Jamtara South GP',
            policeStationPostOffice: 'Jamtara Rural PS',
          ),
        ],
      },
      'Khunti': {

        'Khunti City': [
          const VillageRecord(
            villageName: 'Khunti Rural',
            lgdCode: '500822',
            gramPanchayat: 'Khunti GP',
            policeStationPostOffice: 'Khunti PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khunti North',
            lgdCode: '500823',
            gramPanchayat: 'Khunti Ward 1',
            policeStationPostOffice: 'Khunti PS / PO',
          ),
        ],
        'Khunti Block': [
          const VillageRecord(
            villageName: 'Khunti East',
            lgdCode: '500824',
            gramPanchayat: 'Khunti East GP',
            policeStationPostOffice: 'Khunti Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khunti South',
            lgdCode: '500825',
            gramPanchayat: 'Khunti South GP',
            policeStationPostOffice: 'Khunti Rural PS',
          ),
        ],
      },
      'Koderma': {

        'Koderma City': [
          const VillageRecord(
            villageName: 'Koderma Rural',
            lgdCode: '500826',
            gramPanchayat: 'Koderma GP',
            policeStationPostOffice: 'Koderma PS / PO',
          ),
          const VillageRecord(
            villageName: 'Koderma North',
            lgdCode: '500827',
            gramPanchayat: 'Koderma Ward 1',
            policeStationPostOffice: 'Koderma PS / PO',
          ),
        ],
        'Koderma Block': [
          const VillageRecord(
            villageName: 'Koderma East',
            lgdCode: '500828',
            gramPanchayat: 'Koderma East GP',
            policeStationPostOffice: 'Koderma Rural PS',
          ),
          const VillageRecord(
            villageName: 'Koderma South',
            lgdCode: '500829',
            gramPanchayat: 'Koderma South GP',
            policeStationPostOffice: 'Koderma Rural PS',
          ),
        ],
      },
      'Latehar': {

        'Latehar City': [
          const VillageRecord(
            villageName: 'Latehar Rural',
            lgdCode: '500830',
            gramPanchayat: 'Latehar GP',
            policeStationPostOffice: 'Latehar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Latehar North',
            lgdCode: '500831',
            gramPanchayat: 'Latehar Ward 1',
            policeStationPostOffice: 'Latehar PS / PO',
          ),
        ],
        'Latehar Block': [
          const VillageRecord(
            villageName: 'Latehar East',
            lgdCode: '500832',
            gramPanchayat: 'Latehar East GP',
            policeStationPostOffice: 'Latehar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Latehar South',
            lgdCode: '500833',
            gramPanchayat: 'Latehar South GP',
            policeStationPostOffice: 'Latehar Rural PS',
          ),
        ],
      },
      'Lohardaga': {

        'Lohardaga City': [
          const VillageRecord(
            villageName: 'Lohardaga Rural',
            lgdCode: '500834',
            gramPanchayat: 'Lohardaga GP',
            policeStationPostOffice: 'Lohardaga PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lohardaga North',
            lgdCode: '500835',
            gramPanchayat: 'Lohardaga Ward 1',
            policeStationPostOffice: 'Lohardaga PS / PO',
          ),
        ],
        'Lohardaga Block': [
          const VillageRecord(
            villageName: 'Lohardaga East',
            lgdCode: '500836',
            gramPanchayat: 'Lohardaga East GP',
            policeStationPostOffice: 'Lohardaga Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lohardaga South',
            lgdCode: '500837',
            gramPanchayat: 'Lohardaga South GP',
            policeStationPostOffice: 'Lohardaga Rural PS',
          ),
        ],
      },
      'Pakur': {

        'Pakur City': [
          const VillageRecord(
            villageName: 'Pakur Rural',
            lgdCode: '500838',
            gramPanchayat: 'Pakur GP',
            policeStationPostOffice: 'Pakur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pakur North',
            lgdCode: '500839',
            gramPanchayat: 'Pakur Ward 1',
            policeStationPostOffice: 'Pakur PS / PO',
          ),
        ],
        'Pakur Block': [
          const VillageRecord(
            villageName: 'Pakur East',
            lgdCode: '500840',
            gramPanchayat: 'Pakur East GP',
            policeStationPostOffice: 'Pakur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pakur South',
            lgdCode: '500841',
            gramPanchayat: 'Pakur South GP',
            policeStationPostOffice: 'Pakur Rural PS',
          ),
        ],
      },
      'Palamu': {

        'Palamu City': [
          const VillageRecord(
            villageName: 'Palamu Rural',
            lgdCode: '500842',
            gramPanchayat: 'Palamu GP',
            policeStationPostOffice: 'Palamu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Palamu North',
            lgdCode: '500843',
            gramPanchayat: 'Palamu Ward 1',
            policeStationPostOffice: 'Palamu PS / PO',
          ),
        ],
        'Palamu Block': [
          const VillageRecord(
            villageName: 'Palamu East',
            lgdCode: '500844',
            gramPanchayat: 'Palamu East GP',
            policeStationPostOffice: 'Palamu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Palamu South',
            lgdCode: '500845',
            gramPanchayat: 'Palamu South GP',
            policeStationPostOffice: 'Palamu Rural PS',
          ),
        ],
      },
      'Ramgarh': {

        'Ramgarh City': [
          const VillageRecord(
            villageName: 'Ramgarh Rural',
            lgdCode: '500846',
            gramPanchayat: 'Ramgarh GP',
            policeStationPostOffice: 'Ramgarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ramgarh North',
            lgdCode: '500847',
            gramPanchayat: 'Ramgarh Ward 1',
            policeStationPostOffice: 'Ramgarh PS / PO',
          ),
        ],
        'Ramgarh Block': [
          const VillageRecord(
            villageName: 'Ramgarh East',
            lgdCode: '500848',
            gramPanchayat: 'Ramgarh East GP',
            policeStationPostOffice: 'Ramgarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ramgarh South',
            lgdCode: '500849',
            gramPanchayat: 'Ramgarh South GP',
            policeStationPostOffice: 'Ramgarh Rural PS',
          ),
        ],
      },
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
      'Sahebganj': {

        'Sahebganj City': [
          const VillageRecord(
            villageName: 'Sahebganj Rural',
            lgdCode: '500850',
            gramPanchayat: 'Sahebganj GP',
            policeStationPostOffice: 'Sahebganj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sahebganj North',
            lgdCode: '500851',
            gramPanchayat: 'Sahebganj Ward 1',
            policeStationPostOffice: 'Sahebganj PS / PO',
          ),
        ],
        'Sahebganj Block': [
          const VillageRecord(
            villageName: 'Sahebganj East',
            lgdCode: '500852',
            gramPanchayat: 'Sahebganj East GP',
            policeStationPostOffice: 'Sahebganj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sahebganj South',
            lgdCode: '500853',
            gramPanchayat: 'Sahebganj South GP',
            policeStationPostOffice: 'Sahebganj Rural PS',
          ),
        ],
      },
      'Seraikela Kharsawan': {

        'Seraikela Kharsawan City': [
          const VillageRecord(
            villageName: 'Seraikela Kharsawan Rural',
            lgdCode: '500854',
            gramPanchayat: 'Seraikela Kharsawan GP',
            policeStationPostOffice: 'Seraikela Kharsawan PS / PO',
          ),
          const VillageRecord(
            villageName: 'Seraikela Kharsawan North',
            lgdCode: '500855',
            gramPanchayat: 'Seraikela Kharsawan Ward 1',
            policeStationPostOffice: 'Seraikela Kharsawan PS / PO',
          ),
        ],
        'Seraikela Kharsawan Block': [
          const VillageRecord(
            villageName: 'Seraikela Kharsawan East',
            lgdCode: '500856',
            gramPanchayat: 'Seraikela Kharsawan East GP',
            policeStationPostOffice: 'Seraikela Kharsawan Rural PS',
          ),
          const VillageRecord(
            villageName: 'Seraikela Kharsawan South',
            lgdCode: '500857',
            gramPanchayat: 'Seraikela Kharsawan South GP',
            policeStationPostOffice: 'Seraikela Kharsawan Rural PS',
          ),
        ],
      },
      'Simdega': {

        'Simdega City': [
          const VillageRecord(
            villageName: 'Simdega Rural',
            lgdCode: '500858',
            gramPanchayat: 'Simdega GP',
            policeStationPostOffice: 'Simdega PS / PO',
          ),
          const VillageRecord(
            villageName: 'Simdega North',
            lgdCode: '500859',
            gramPanchayat: 'Simdega Ward 1',
            policeStationPostOffice: 'Simdega PS / PO',
          ),
        ],
        'Simdega Block': [
          const VillageRecord(
            villageName: 'Simdega East',
            lgdCode: '500860',
            gramPanchayat: 'Simdega East GP',
            policeStationPostOffice: 'Simdega Rural PS',
          ),
          const VillageRecord(
            villageName: 'Simdega South',
            lgdCode: '500861',
            gramPanchayat: 'Simdega South GP',
            policeStationPostOffice: 'Simdega Rural PS',
          ),
        ],
      },
      'West Singhbhum': {

        'West Singhbhum City': [
          const VillageRecord(
            villageName: 'West Singhbhum Rural',
            lgdCode: '500862',
            gramPanchayat: 'West Singhbhum GP',
            policeStationPostOffice: 'West Singhbhum PS / PO',
          ),
          const VillageRecord(
            villageName: 'West Singhbhum North',
            lgdCode: '500863',
            gramPanchayat: 'West Singhbhum Ward 1',
            policeStationPostOffice: 'West Singhbhum PS / PO',
          ),
        ],
        'West Singhbhum Block': [
          const VillageRecord(
            villageName: 'West Singhbhum East',
            lgdCode: '500864',
            gramPanchayat: 'West Singhbhum East GP',
            policeStationPostOffice: 'West Singhbhum Rural PS',
          ),
          const VillageRecord(
            villageName: 'West Singhbhum South',
            lgdCode: '500865',
            gramPanchayat: 'West Singhbhum South GP',
            policeStationPostOffice: 'West Singhbhum Rural PS',
          ),
        ],
      },
    },
    'Karnataka': {
      'Bagalkot': {
        'Bagalkot City': [
          const VillageRecord(
            villageName: 'Bagalkot Rural',
            lgdCode: '500002',
            gramPanchayat: 'Bagalkot GP',
            policeStationPostOffice: 'Bagalkot PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bagalkot North',
            lgdCode: '500003',
            gramPanchayat: 'Bagalkot Ward 1',
            policeStationPostOffice: 'Bagalkot PS / PO',
          ),
        ],
        'Bagalkot Block': [
          const VillageRecord(
            villageName: 'Bagalkot East',
            lgdCode: '500004',
            gramPanchayat: 'Bagalkot East GP',
            policeStationPostOffice: 'Bagalkot Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bagalkot South',
            lgdCode: '500005',
            gramPanchayat: 'Bagalkot South GP',
            policeStationPostOffice: 'Bagalkot Rural PS',
          ),
        ],
      },
      'Ballari (Bellary)': {
        'Ballari (Bellary) City': [
          const VillageRecord(
            villageName: 'Ballari (Bellary) Rural',
            lgdCode: '500006',
            gramPanchayat: 'Ballari (Bellary) GP',
            policeStationPostOffice: 'Ballari (Bellary) PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ballari (Bellary) North',
            lgdCode: '500007',
            gramPanchayat: 'Ballari (Bellary) Ward 1',
            policeStationPostOffice: 'Ballari (Bellary) PS / PO',
          ),
        ],
        'Ballari (Bellary) Block': [
          const VillageRecord(
            villageName: 'Ballari (Bellary) East',
            lgdCode: '500008',
            gramPanchayat: 'Ballari (Bellary) East GP',
            policeStationPostOffice: 'Ballari (Bellary) Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ballari (Bellary) South',
            lgdCode: '500009',
            gramPanchayat: 'Ballari (Bellary) South GP',
            policeStationPostOffice: 'Ballari (Bellary) Rural PS',
          ),
        ],
      },
      'Belagavi': {
        'Belagavi City': [
          const VillageRecord(
            villageName: 'Belagavi Rural',
            lgdCode: '500010',
            gramPanchayat: 'Belagavi GP',
            policeStationPostOffice: 'Belagavi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Belagavi North',
            lgdCode: '500011',
            gramPanchayat: 'Belagavi Ward 1',
            policeStationPostOffice: 'Belagavi PS / PO',
          ),
        ],
        'Belagavi Block': [
          const VillageRecord(
            villageName: 'Belagavi East',
            lgdCode: '500012',
            gramPanchayat: 'Belagavi East GP',
            policeStationPostOffice: 'Belagavi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Belagavi South',
            lgdCode: '500013',
            gramPanchayat: 'Belagavi South GP',
            policeStationPostOffice: 'Belagavi Rural PS',
          ),
        ],
      },
      'Bengaluru Rural': {
        'Bengaluru Rural City': [
          const VillageRecord(
            villageName: 'Bengaluru Rural Rural',
            lgdCode: '500014',
            gramPanchayat: 'Bengaluru Rural GP',
            policeStationPostOffice: 'Bengaluru Rural PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bengaluru Rural North',
            lgdCode: '500015',
            gramPanchayat: 'Bengaluru Rural Ward 1',
            policeStationPostOffice: 'Bengaluru Rural PS / PO',
          ),
        ],
        'Bengaluru Rural Block': [
          const VillageRecord(
            villageName: 'Bengaluru Rural East',
            lgdCode: '500016',
            gramPanchayat: 'Bengaluru Rural East GP',
            policeStationPostOffice: 'Bengaluru Rural Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bengaluru Rural South',
            lgdCode: '500017',
            gramPanchayat: 'Bengaluru Rural South GP',
            policeStationPostOffice: 'Bengaluru Rural Rural PS',
          ),
        ],
      },
      'Bengaluru Urban': {
        'Bengaluru Urban City': [
          const VillageRecord(
            villageName: 'Bengaluru Urban Rural',
            lgdCode: '500018',
            gramPanchayat: 'Bengaluru Urban GP',
            policeStationPostOffice: 'Bengaluru Urban PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bengaluru Urban North',
            lgdCode: '500019',
            gramPanchayat: 'Bengaluru Urban Ward 1',
            policeStationPostOffice: 'Bengaluru Urban PS / PO',
          ),
        ],
        'Bengaluru Urban Block': [
          const VillageRecord(
            villageName: 'Bengaluru Urban East',
            lgdCode: '500020',
            gramPanchayat: 'Bengaluru Urban East GP',
            policeStationPostOffice: 'Bengaluru Urban Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bengaluru Urban South',
            lgdCode: '500021',
            gramPanchayat: 'Bengaluru Urban South GP',
            policeStationPostOffice: 'Bengaluru Urban Rural PS',
          ),
        ],
      },
      'Bidar': {
        'Bidar City': [
          const VillageRecord(
            villageName: 'Bidar Rural',
            lgdCode: '500022',
            gramPanchayat: 'Bidar GP',
            policeStationPostOffice: 'Bidar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bidar North',
            lgdCode: '500023',
            gramPanchayat: 'Bidar Ward 1',
            policeStationPostOffice: 'Bidar PS / PO',
          ),
        ],
        'Bidar Block': [
          const VillageRecord(
            villageName: 'Bidar East',
            lgdCode: '500024',
            gramPanchayat: 'Bidar East GP',
            policeStationPostOffice: 'Bidar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bidar South',
            lgdCode: '500025',
            gramPanchayat: 'Bidar South GP',
            policeStationPostOffice: 'Bidar Rural PS',
          ),
        ],
      },
      'Chamarajanagar': {
        'Chamarajanagar City': [
          const VillageRecord(
            villageName: 'Chamarajanagar Rural',
            lgdCode: '500026',
            gramPanchayat: 'Chamarajanagar GP',
            policeStationPostOffice: 'Chamarajanagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chamarajanagar North',
            lgdCode: '500027',
            gramPanchayat: 'Chamarajanagar Ward 1',
            policeStationPostOffice: 'Chamarajanagar PS / PO',
          ),
        ],
        'Chamarajanagar Block': [
          const VillageRecord(
            villageName: 'Chamarajanagar East',
            lgdCode: '500028',
            gramPanchayat: 'Chamarajanagar East GP',
            policeStationPostOffice: 'Chamarajanagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chamarajanagar South',
            lgdCode: '500029',
            gramPanchayat: 'Chamarajanagar South GP',
            policeStationPostOffice: 'Chamarajanagar Rural PS',
          ),
        ],
      },
      'Chikkaballapur': {
        'Chikkaballapur City': [
          const VillageRecord(
            villageName: 'Chikkaballapur Rural',
            lgdCode: '500030',
            gramPanchayat: 'Chikkaballapur GP',
            policeStationPostOffice: 'Chikkaballapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chikkaballapur North',
            lgdCode: '500031',
            gramPanchayat: 'Chikkaballapur Ward 1',
            policeStationPostOffice: 'Chikkaballapur PS / PO',
          ),
        ],
        'Chikkaballapur Block': [
          const VillageRecord(
            villageName: 'Chikkaballapur East',
            lgdCode: '500032',
            gramPanchayat: 'Chikkaballapur East GP',
            policeStationPostOffice: 'Chikkaballapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chikkaballapur South',
            lgdCode: '500033',
            gramPanchayat: 'Chikkaballapur South GP',
            policeStationPostOffice: 'Chikkaballapur Rural PS',
          ),
        ],
      },
      'Chikkamagaluru': {
        'Chikkamagaluru City': [
          const VillageRecord(
            villageName: 'Chikkamagaluru Rural',
            lgdCode: '500034',
            gramPanchayat: 'Chikkamagaluru GP',
            policeStationPostOffice: 'Chikkamagaluru PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chikkamagaluru North',
            lgdCode: '500035',
            gramPanchayat: 'Chikkamagaluru Ward 1',
            policeStationPostOffice: 'Chikkamagaluru PS / PO',
          ),
        ],
        'Chikkamagaluru Block': [
          const VillageRecord(
            villageName: 'Chikkamagaluru East',
            lgdCode: '500036',
            gramPanchayat: 'Chikkamagaluru East GP',
            policeStationPostOffice: 'Chikkamagaluru Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chikkamagaluru South',
            lgdCode: '500037',
            gramPanchayat: 'Chikkamagaluru South GP',
            policeStationPostOffice: 'Chikkamagaluru Rural PS',
          ),
        ],
      },
      'Chitradurga': {
        'Chitradurga City': [
          const VillageRecord(
            villageName: 'Chitradurga Rural',
            lgdCode: '500038',
            gramPanchayat: 'Chitradurga GP',
            policeStationPostOffice: 'Chitradurga PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chitradurga North',
            lgdCode: '500039',
            gramPanchayat: 'Chitradurga Ward 1',
            policeStationPostOffice: 'Chitradurga PS / PO',
          ),
        ],
        'Chitradurga Block': [
          const VillageRecord(
            villageName: 'Chitradurga East',
            lgdCode: '500040',
            gramPanchayat: 'Chitradurga East GP',
            policeStationPostOffice: 'Chitradurga Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chitradurga South',
            lgdCode: '500041',
            gramPanchayat: 'Chitradurga South GP',
            policeStationPostOffice: 'Chitradurga Rural PS',
          ),
        ],
      },
      'Dakshina Kannada': {
        'Dakshina Kannada City': [
          const VillageRecord(
            villageName: 'Dakshina Kannada Rural',
            lgdCode: '500042',
            gramPanchayat: 'Dakshina Kannada GP',
            policeStationPostOffice: 'Dakshina Kannada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dakshina Kannada North',
            lgdCode: '500043',
            gramPanchayat: 'Dakshina Kannada Ward 1',
            policeStationPostOffice: 'Dakshina Kannada PS / PO',
          ),
        ],
        'Dakshina Kannada Block': [
          const VillageRecord(
            villageName: 'Dakshina Kannada East',
            lgdCode: '500044',
            gramPanchayat: 'Dakshina Kannada East GP',
            policeStationPostOffice: 'Dakshina Kannada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dakshina Kannada South',
            lgdCode: '500045',
            gramPanchayat: 'Dakshina Kannada South GP',
            policeStationPostOffice: 'Dakshina Kannada Rural PS',
          ),
        ],
      },
      'Davanagere': {
        'Davanagere City': [
          const VillageRecord(
            villageName: 'Davanagere Rural',
            lgdCode: '500046',
            gramPanchayat: 'Davanagere GP',
            policeStationPostOffice: 'Davanagere PS / PO',
          ),
          const VillageRecord(
            villageName: 'Davanagere North',
            lgdCode: '500047',
            gramPanchayat: 'Davanagere Ward 1',
            policeStationPostOffice: 'Davanagere PS / PO',
          ),
        ],
        'Davanagere Block': [
          const VillageRecord(
            villageName: 'Davanagere East',
            lgdCode: '500048',
            gramPanchayat: 'Davanagere East GP',
            policeStationPostOffice: 'Davanagere Rural PS',
          ),
          const VillageRecord(
            villageName: 'Davanagere South',
            lgdCode: '500049',
            gramPanchayat: 'Davanagere South GP',
            policeStationPostOffice: 'Davanagere Rural PS',
          ),
        ],
      },
      'Dharwad': {
        'Dharwad City': [
          const VillageRecord(
            villageName: 'Dharwad Rural',
            lgdCode: '500050',
            gramPanchayat: 'Dharwad GP',
            policeStationPostOffice: 'Dharwad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dharwad North',
            lgdCode: '500051',
            gramPanchayat: 'Dharwad Ward 1',
            policeStationPostOffice: 'Dharwad PS / PO',
          ),
        ],
        'Dharwad Block': [
          const VillageRecord(
            villageName: 'Dharwad East',
            lgdCode: '500052',
            gramPanchayat: 'Dharwad East GP',
            policeStationPostOffice: 'Dharwad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dharwad South',
            lgdCode: '500053',
            gramPanchayat: 'Dharwad South GP',
            policeStationPostOffice: 'Dharwad Rural PS',
          ),
        ],
      },
      'Gadag': {
        'Gadag City': [
          const VillageRecord(
            villageName: 'Gadag Rural',
            lgdCode: '500054',
            gramPanchayat: 'Gadag GP',
            policeStationPostOffice: 'Gadag PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gadag North',
            lgdCode: '500055',
            gramPanchayat: 'Gadag Ward 1',
            policeStationPostOffice: 'Gadag PS / PO',
          ),
        ],
        'Gadag Block': [
          const VillageRecord(
            villageName: 'Gadag East',
            lgdCode: '500056',
            gramPanchayat: 'Gadag East GP',
            policeStationPostOffice: 'Gadag Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gadag South',
            lgdCode: '500057',
            gramPanchayat: 'Gadag South GP',
            policeStationPostOffice: 'Gadag Rural PS',
          ),
        ],
      },
      'Hassan': {
        'Hassan City': [
          const VillageRecord(
            villageName: 'Hassan Rural',
            lgdCode: '500058',
            gramPanchayat: 'Hassan GP',
            policeStationPostOffice: 'Hassan PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hassan North',
            lgdCode: '500059',
            gramPanchayat: 'Hassan Ward 1',
            policeStationPostOffice: 'Hassan PS / PO',
          ),
        ],
        'Hassan Block': [
          const VillageRecord(
            villageName: 'Hassan East',
            lgdCode: '500060',
            gramPanchayat: 'Hassan East GP',
            policeStationPostOffice: 'Hassan Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hassan South',
            lgdCode: '500061',
            gramPanchayat: 'Hassan South GP',
            policeStationPostOffice: 'Hassan Rural PS',
          ),
        ],
      },
      'Haveri': {
        'Haveri City': [
          const VillageRecord(
            villageName: 'Haveri Rural',
            lgdCode: '500062',
            gramPanchayat: 'Haveri GP',
            policeStationPostOffice: 'Haveri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Haveri North',
            lgdCode: '500063',
            gramPanchayat: 'Haveri Ward 1',
            policeStationPostOffice: 'Haveri PS / PO',
          ),
        ],
        'Haveri Block': [
          const VillageRecord(
            villageName: 'Haveri East',
            lgdCode: '500064',
            gramPanchayat: 'Haveri East GP',
            policeStationPostOffice: 'Haveri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Haveri South',
            lgdCode: '500065',
            gramPanchayat: 'Haveri South GP',
            policeStationPostOffice: 'Haveri Rural PS',
          ),
        ],
      },
      'Kalaburagi': {
        'Kalaburagi City': [
          const VillageRecord(
            villageName: 'Kalaburagi Rural',
            lgdCode: '500066',
            gramPanchayat: 'Kalaburagi GP',
            policeStationPostOffice: 'Kalaburagi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kalaburagi North',
            lgdCode: '500067',
            gramPanchayat: 'Kalaburagi Ward 1',
            policeStationPostOffice: 'Kalaburagi PS / PO',
          ),
        ],
        'Kalaburagi Block': [
          const VillageRecord(
            villageName: 'Kalaburagi East',
            lgdCode: '500068',
            gramPanchayat: 'Kalaburagi East GP',
            policeStationPostOffice: 'Kalaburagi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kalaburagi South',
            lgdCode: '500069',
            gramPanchayat: 'Kalaburagi South GP',
            policeStationPostOffice: 'Kalaburagi Rural PS',
          ),
        ],
      },
      'Kodagu': {
        'Kodagu City': [
          const VillageRecord(
            villageName: 'Kodagu Rural',
            lgdCode: '500070',
            gramPanchayat: 'Kodagu GP',
            policeStationPostOffice: 'Kodagu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kodagu North',
            lgdCode: '500071',
            gramPanchayat: 'Kodagu Ward 1',
            policeStationPostOffice: 'Kodagu PS / PO',
          ),
        ],
        'Kodagu Block': [
          const VillageRecord(
            villageName: 'Kodagu East',
            lgdCode: '500072',
            gramPanchayat: 'Kodagu East GP',
            policeStationPostOffice: 'Kodagu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kodagu South',
            lgdCode: '500073',
            gramPanchayat: 'Kodagu South GP',
            policeStationPostOffice: 'Kodagu Rural PS',
          ),
        ],
      },
      'Kolar': {
        'Kolar City': [
          const VillageRecord(
            villageName: 'Kolar Rural',
            lgdCode: '500074',
            gramPanchayat: 'Kolar GP',
            policeStationPostOffice: 'Kolar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kolar North',
            lgdCode: '500075',
            gramPanchayat: 'Kolar Ward 1',
            policeStationPostOffice: 'Kolar PS / PO',
          ),
        ],
        'Kolar Block': [
          const VillageRecord(
            villageName: 'Kolar East',
            lgdCode: '500076',
            gramPanchayat: 'Kolar East GP',
            policeStationPostOffice: 'Kolar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kolar South',
            lgdCode: '500077',
            gramPanchayat: 'Kolar South GP',
            policeStationPostOffice: 'Kolar Rural PS',
          ),
        ],
      },
      'Koppal': {
        'Koppal City': [
          const VillageRecord(
            villageName: 'Koppal Rural',
            lgdCode: '500078',
            gramPanchayat: 'Koppal GP',
            policeStationPostOffice: 'Koppal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Koppal North',
            lgdCode: '500079',
            gramPanchayat: 'Koppal Ward 1',
            policeStationPostOffice: 'Koppal PS / PO',
          ),
        ],
        'Koppal Block': [
          const VillageRecord(
            villageName: 'Koppal East',
            lgdCode: '500080',
            gramPanchayat: 'Koppal East GP',
            policeStationPostOffice: 'Koppal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Koppal South',
            lgdCode: '500081',
            gramPanchayat: 'Koppal South GP',
            policeStationPostOffice: 'Koppal Rural PS',
          ),
        ],
      },
      'Mandya': {
        'Mandya City': [
          const VillageRecord(
            villageName: 'Mandya Rural',
            lgdCode: '500082',
            gramPanchayat: 'Mandya GP',
            policeStationPostOffice: 'Mandya PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mandya North',
            lgdCode: '500083',
            gramPanchayat: 'Mandya Ward 1',
            policeStationPostOffice: 'Mandya PS / PO',
          ),
        ],
        'Mandya Block': [
          const VillageRecord(
            villageName: 'Mandya East',
            lgdCode: '500084',
            gramPanchayat: 'Mandya East GP',
            policeStationPostOffice: 'Mandya Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mandya South',
            lgdCode: '500085',
            gramPanchayat: 'Mandya South GP',
            policeStationPostOffice: 'Mandya Rural PS',
          ),
        ],
      },
      'Mysuru': {
        'Mysuru City': [
          const VillageRecord(
            villageName: 'Mysuru Rural',
            lgdCode: '500086',
            gramPanchayat: 'Mysuru GP',
            policeStationPostOffice: 'Mysuru PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mysuru North',
            lgdCode: '500087',
            gramPanchayat: 'Mysuru Ward 1',
            policeStationPostOffice: 'Mysuru PS / PO',
          ),
        ],
        'Mysuru Block': [
          const VillageRecord(
            villageName: 'Mysuru East',
            lgdCode: '500088',
            gramPanchayat: 'Mysuru East GP',
            policeStationPostOffice: 'Mysuru Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mysuru South',
            lgdCode: '500089',
            gramPanchayat: 'Mysuru South GP',
            policeStationPostOffice: 'Mysuru Rural PS',
          ),
        ],
      },
      'Raichur': {
        'Raichur City': [
          const VillageRecord(
            villageName: 'Raichur Rural',
            lgdCode: '500090',
            gramPanchayat: 'Raichur GP',
            policeStationPostOffice: 'Raichur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Raichur North',
            lgdCode: '500091',
            gramPanchayat: 'Raichur Ward 1',
            policeStationPostOffice: 'Raichur PS / PO',
          ),
        ],
        'Raichur Block': [
          const VillageRecord(
            villageName: 'Raichur East',
            lgdCode: '500092',
            gramPanchayat: 'Raichur East GP',
            policeStationPostOffice: 'Raichur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Raichur South',
            lgdCode: '500093',
            gramPanchayat: 'Raichur South GP',
            policeStationPostOffice: 'Raichur Rural PS',
          ),
        ],
      },
      'Ramanagara': {
        'Ramanagara City': [
          const VillageRecord(
            villageName: 'Ramanagara Rural',
            lgdCode: '500094',
            gramPanchayat: 'Ramanagara GP',
            policeStationPostOffice: 'Ramanagara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ramanagara North',
            lgdCode: '500095',
            gramPanchayat: 'Ramanagara Ward 1',
            policeStationPostOffice: 'Ramanagara PS / PO',
          ),
        ],
        'Ramanagara Block': [
          const VillageRecord(
            villageName: 'Ramanagara East',
            lgdCode: '500096',
            gramPanchayat: 'Ramanagara East GP',
            policeStationPostOffice: 'Ramanagara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ramanagara South',
            lgdCode: '500097',
            gramPanchayat: 'Ramanagara South GP',
            policeStationPostOffice: 'Ramanagara Rural PS',
          ),
        ],
      },
      'Shivamogga': {
        'Shivamogga City': [
          const VillageRecord(
            villageName: 'Shivamogga Rural',
            lgdCode: '500098',
            gramPanchayat: 'Shivamogga GP',
            policeStationPostOffice: 'Shivamogga PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shivamogga North',
            lgdCode: '500099',
            gramPanchayat: 'Shivamogga Ward 1',
            policeStationPostOffice: 'Shivamogga PS / PO',
          ),
        ],
        'Shivamogga Block': [
          const VillageRecord(
            villageName: 'Shivamogga East',
            lgdCode: '500100',
            gramPanchayat: 'Shivamogga East GP',
            policeStationPostOffice: 'Shivamogga Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shivamogga South',
            lgdCode: '500101',
            gramPanchayat: 'Shivamogga South GP',
            policeStationPostOffice: 'Shivamogga Rural PS',
          ),
        ],
      },
      'Tumakuru': {
        'Tumakuru City': [
          const VillageRecord(
            villageName: 'Tumakuru Rural',
            lgdCode: '500102',
            gramPanchayat: 'Tumakuru GP',
            policeStationPostOffice: 'Tumakuru PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tumakuru North',
            lgdCode: '500103',
            gramPanchayat: 'Tumakuru Ward 1',
            policeStationPostOffice: 'Tumakuru PS / PO',
          ),
        ],
        'Tumakuru Block': [
          const VillageRecord(
            villageName: 'Tumakuru East',
            lgdCode: '500104',
            gramPanchayat: 'Tumakuru East GP',
            policeStationPostOffice: 'Tumakuru Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tumakuru South',
            lgdCode: '500105',
            gramPanchayat: 'Tumakuru South GP',
            policeStationPostOffice: 'Tumakuru Rural PS',
          ),
        ],
      },
      'Udupi': {
        'Udupi City': [
          const VillageRecord(
            villageName: 'Udupi Rural',
            lgdCode: '500106',
            gramPanchayat: 'Udupi GP',
            policeStationPostOffice: 'Udupi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Udupi North',
            lgdCode: '500107',
            gramPanchayat: 'Udupi Ward 1',
            policeStationPostOffice: 'Udupi PS / PO',
          ),
        ],
        'Udupi Block': [
          const VillageRecord(
            villageName: 'Udupi East',
            lgdCode: '500108',
            gramPanchayat: 'Udupi East GP',
            policeStationPostOffice: 'Udupi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Udupi South',
            lgdCode: '500109',
            gramPanchayat: 'Udupi South GP',
            policeStationPostOffice: 'Udupi Rural PS',
          ),
        ],
      },
      'Uttara Kannada': {
        'Uttara Kannada City': [
          const VillageRecord(
            villageName: 'Uttara Kannada Rural',
            lgdCode: '500110',
            gramPanchayat: 'Uttara Kannada GP',
            policeStationPostOffice: 'Uttara Kannada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Uttara Kannada North',
            lgdCode: '500111',
            gramPanchayat: 'Uttara Kannada Ward 1',
            policeStationPostOffice: 'Uttara Kannada PS / PO',
          ),
        ],
        'Uttara Kannada Block': [
          const VillageRecord(
            villageName: 'Uttara Kannada East',
            lgdCode: '500112',
            gramPanchayat: 'Uttara Kannada East GP',
            policeStationPostOffice: 'Uttara Kannada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Uttara Kannada South',
            lgdCode: '500113',
            gramPanchayat: 'Uttara Kannada South GP',
            policeStationPostOffice: 'Uttara Kannada Rural PS',
          ),
        ],
      },
      'Vijayanagara': {
        'Vijayanagara City': [
          const VillageRecord(
            villageName: 'Vijayanagara Rural',
            lgdCode: '500114',
            gramPanchayat: 'Vijayanagara GP',
            policeStationPostOffice: 'Vijayanagara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Vijayanagara North',
            lgdCode: '500115',
            gramPanchayat: 'Vijayanagara Ward 1',
            policeStationPostOffice: 'Vijayanagara PS / PO',
          ),
        ],
        'Vijayanagara Block': [
          const VillageRecord(
            villageName: 'Vijayanagara East',
            lgdCode: '500116',
            gramPanchayat: 'Vijayanagara East GP',
            policeStationPostOffice: 'Vijayanagara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Vijayanagara South',
            lgdCode: '500117',
            gramPanchayat: 'Vijayanagara South GP',
            policeStationPostOffice: 'Vijayanagara Rural PS',
          ),
        ],
      },
      'Vijayapura': {
        'Vijayapura City': [
          const VillageRecord(
            villageName: 'Vijayapura Rural',
            lgdCode: '500118',
            gramPanchayat: 'Vijayapura GP',
            policeStationPostOffice: 'Vijayapura PS / PO',
          ),
          const VillageRecord(
            villageName: 'Vijayapura North',
            lgdCode: '500119',
            gramPanchayat: 'Vijayapura Ward 1',
            policeStationPostOffice: 'Vijayapura PS / PO',
          ),
        ],
        'Vijayapura Block': [
          const VillageRecord(
            villageName: 'Vijayapura East',
            lgdCode: '500120',
            gramPanchayat: 'Vijayapura East GP',
            policeStationPostOffice: 'Vijayapura Rural PS',
          ),
          const VillageRecord(
            villageName: 'Vijayapura South',
            lgdCode: '500121',
            gramPanchayat: 'Vijayapura South GP',
            policeStationPostOffice: 'Vijayapura Rural PS',
          ),
        ],
      },
      'Yadgir': {
        'Yadgir City': [
          const VillageRecord(
            villageName: 'Yadgir Rural',
            lgdCode: '500122',
            gramPanchayat: 'Yadgir GP',
            policeStationPostOffice: 'Yadgir PS / PO',
          ),
          const VillageRecord(
            villageName: 'Yadgir North',
            lgdCode: '500123',
            gramPanchayat: 'Yadgir Ward 1',
            policeStationPostOffice: 'Yadgir PS / PO',
          ),
        ],
        'Yadgir Block': [
          const VillageRecord(
            villageName: 'Yadgir East',
            lgdCode: '500124',
            gramPanchayat: 'Yadgir East GP',
            policeStationPostOffice: 'Yadgir Rural PS',
          ),
          const VillageRecord(
            villageName: 'Yadgir South',
            lgdCode: '500125',
            gramPanchayat: 'Yadgir South GP',
            policeStationPostOffice: 'Yadgir Rural PS',
          ),
        ],
      },
    },
    'Kerala': {
      'Alappuzha': {

        'Alappuzha City': [
          const VillageRecord(
            villageName: 'Alappuzha Rural',
            lgdCode: '500866',
            gramPanchayat: 'Alappuzha GP',
            policeStationPostOffice: 'Alappuzha PS / PO',
          ),
          const VillageRecord(
            villageName: 'Alappuzha North',
            lgdCode: '500867',
            gramPanchayat: 'Alappuzha Ward 1',
            policeStationPostOffice: 'Alappuzha PS / PO',
          ),
        ],
        'Alappuzha Block': [
          const VillageRecord(
            villageName: 'Alappuzha East',
            lgdCode: '500868',
            gramPanchayat: 'Alappuzha East GP',
            policeStationPostOffice: 'Alappuzha Rural PS',
          ),
          const VillageRecord(
            villageName: 'Alappuzha South',
            lgdCode: '500869',
            gramPanchayat: 'Alappuzha South GP',
            policeStationPostOffice: 'Alappuzha Rural PS',
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
      'Idukki': {

        'Idukki City': [
          const VillageRecord(
            villageName: 'Idukki Rural',
            lgdCode: '500870',
            gramPanchayat: 'Idukki GP',
            policeStationPostOffice: 'Idukki PS / PO',
          ),
          const VillageRecord(
            villageName: 'Idukki North',
            lgdCode: '500871',
            gramPanchayat: 'Idukki Ward 1',
            policeStationPostOffice: 'Idukki PS / PO',
          ),
        ],
        'Idukki Block': [
          const VillageRecord(
            villageName: 'Idukki East',
            lgdCode: '500872',
            gramPanchayat: 'Idukki East GP',
            policeStationPostOffice: 'Idukki Rural PS',
          ),
          const VillageRecord(
            villageName: 'Idukki South',
            lgdCode: '500873',
            gramPanchayat: 'Idukki South GP',
            policeStationPostOffice: 'Idukki Rural PS',
          ),
        ],
      },
      'Kannur': {

        'Kannur City': [
          const VillageRecord(
            villageName: 'Kannur Rural',
            lgdCode: '500874',
            gramPanchayat: 'Kannur GP',
            policeStationPostOffice: 'Kannur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kannur North',
            lgdCode: '500875',
            gramPanchayat: 'Kannur Ward 1',
            policeStationPostOffice: 'Kannur PS / PO',
          ),
        ],
        'Kannur Block': [
          const VillageRecord(
            villageName: 'Kannur East',
            lgdCode: '500876',
            gramPanchayat: 'Kannur East GP',
            policeStationPostOffice: 'Kannur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kannur South',
            lgdCode: '500877',
            gramPanchayat: 'Kannur South GP',
            policeStationPostOffice: 'Kannur Rural PS',
          ),
        ],
      },
      'Kasaragod': {

        'Kasaragod City': [
          const VillageRecord(
            villageName: 'Kasaragod Rural',
            lgdCode: '500878',
            gramPanchayat: 'Kasaragod GP',
            policeStationPostOffice: 'Kasaragod PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kasaragod North',
            lgdCode: '500879',
            gramPanchayat: 'Kasaragod Ward 1',
            policeStationPostOffice: 'Kasaragod PS / PO',
          ),
        ],
        'Kasaragod Block': [
          const VillageRecord(
            villageName: 'Kasaragod East',
            lgdCode: '500880',
            gramPanchayat: 'Kasaragod East GP',
            policeStationPostOffice: 'Kasaragod Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kasaragod South',
            lgdCode: '500881',
            gramPanchayat: 'Kasaragod South GP',
            policeStationPostOffice: 'Kasaragod Rural PS',
          ),
        ],
      },
      'Kollam': {

        'Kollam City': [
          const VillageRecord(
            villageName: 'Kollam Rural',
            lgdCode: '500882',
            gramPanchayat: 'Kollam GP',
            policeStationPostOffice: 'Kollam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kollam North',
            lgdCode: '500883',
            gramPanchayat: 'Kollam Ward 1',
            policeStationPostOffice: 'Kollam PS / PO',
          ),
        ],
        'Kollam Block': [
          const VillageRecord(
            villageName: 'Kollam East',
            lgdCode: '500884',
            gramPanchayat: 'Kollam East GP',
            policeStationPostOffice: 'Kollam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kollam South',
            lgdCode: '500885',
            gramPanchayat: 'Kollam South GP',
            policeStationPostOffice: 'Kollam Rural PS',
          ),
        ],
      },
      'Kottayam': {

        'Kottayam City': [
          const VillageRecord(
            villageName: 'Kottayam Rural',
            lgdCode: '500886',
            gramPanchayat: 'Kottayam GP',
            policeStationPostOffice: 'Kottayam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kottayam North',
            lgdCode: '500887',
            gramPanchayat: 'Kottayam Ward 1',
            policeStationPostOffice: 'Kottayam PS / PO',
          ),
        ],
        'Kottayam Block': [
          const VillageRecord(
            villageName: 'Kottayam East',
            lgdCode: '500888',
            gramPanchayat: 'Kottayam East GP',
            policeStationPostOffice: 'Kottayam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kottayam South',
            lgdCode: '500889',
            gramPanchayat: 'Kottayam South GP',
            policeStationPostOffice: 'Kottayam Rural PS',
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
      'Malappuram': {

        'Malappuram City': [
          const VillageRecord(
            villageName: 'Malappuram Rural',
            lgdCode: '500890',
            gramPanchayat: 'Malappuram GP',
            policeStationPostOffice: 'Malappuram PS / PO',
          ),
          const VillageRecord(
            villageName: 'Malappuram North',
            lgdCode: '500891',
            gramPanchayat: 'Malappuram Ward 1',
            policeStationPostOffice: 'Malappuram PS / PO',
          ),
        ],
        'Malappuram Block': [
          const VillageRecord(
            villageName: 'Malappuram East',
            lgdCode: '500892',
            gramPanchayat: 'Malappuram East GP',
            policeStationPostOffice: 'Malappuram Rural PS',
          ),
          const VillageRecord(
            villageName: 'Malappuram South',
            lgdCode: '500893',
            gramPanchayat: 'Malappuram South GP',
            policeStationPostOffice: 'Malappuram Rural PS',
          ),
        ],
      },
      'Palakkad': {

        'Palakkad City': [
          const VillageRecord(
            villageName: 'Palakkad Rural',
            lgdCode: '500894',
            gramPanchayat: 'Palakkad GP',
            policeStationPostOffice: 'Palakkad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Palakkad North',
            lgdCode: '500895',
            gramPanchayat: 'Palakkad Ward 1',
            policeStationPostOffice: 'Palakkad PS / PO',
          ),
        ],
        'Palakkad Block': [
          const VillageRecord(
            villageName: 'Palakkad East',
            lgdCode: '500896',
            gramPanchayat: 'Palakkad East GP',
            policeStationPostOffice: 'Palakkad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Palakkad South',
            lgdCode: '500897',
            gramPanchayat: 'Palakkad South GP',
            policeStationPostOffice: 'Palakkad Rural PS',
          ),
        ],
      },
      'Pathanamthitta': {

        'Pathanamthitta City': [
          const VillageRecord(
            villageName: 'Pathanamthitta Rural',
            lgdCode: '500898',
            gramPanchayat: 'Pathanamthitta GP',
            policeStationPostOffice: 'Pathanamthitta PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pathanamthitta North',
            lgdCode: '500899',
            gramPanchayat: 'Pathanamthitta Ward 1',
            policeStationPostOffice: 'Pathanamthitta PS / PO',
          ),
        ],
        'Pathanamthitta Block': [
          const VillageRecord(
            villageName: 'Pathanamthitta East',
            lgdCode: '500900',
            gramPanchayat: 'Pathanamthitta East GP',
            policeStationPostOffice: 'Pathanamthitta Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pathanamthitta South',
            lgdCode: '500901',
            gramPanchayat: 'Pathanamthitta South GP',
            policeStationPostOffice: 'Pathanamthitta Rural PS',
          ),
        ],
      },
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
      'Thrissur': {

        'Thrissur City': [
          const VillageRecord(
            villageName: 'Thrissur Rural',
            lgdCode: '500902',
            gramPanchayat: 'Thrissur GP',
            policeStationPostOffice: 'Thrissur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Thrissur North',
            lgdCode: '500903',
            gramPanchayat: 'Thrissur Ward 1',
            policeStationPostOffice: 'Thrissur PS / PO',
          ),
        ],
        'Thrissur Block': [
          const VillageRecord(
            villageName: 'Thrissur East',
            lgdCode: '500904',
            gramPanchayat: 'Thrissur East GP',
            policeStationPostOffice: 'Thrissur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Thrissur South',
            lgdCode: '500905',
            gramPanchayat: 'Thrissur South GP',
            policeStationPostOffice: 'Thrissur Rural PS',
          ),
        ],
      },
      'Wayanad': {

        'Wayanad City': [
          const VillageRecord(
            villageName: 'Wayanad Rural',
            lgdCode: '500906',
            gramPanchayat: 'Wayanad GP',
            policeStationPostOffice: 'Wayanad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Wayanad North',
            lgdCode: '500907',
            gramPanchayat: 'Wayanad Ward 1',
            policeStationPostOffice: 'Wayanad PS / PO',
          ),
        ],
        'Wayanad Block': [
          const VillageRecord(
            villageName: 'Wayanad East',
            lgdCode: '500908',
            gramPanchayat: 'Wayanad East GP',
            policeStationPostOffice: 'Wayanad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Wayanad South',
            lgdCode: '500909',
            gramPanchayat: 'Wayanad South GP',
            policeStationPostOffice: 'Wayanad Rural PS',
          ),
        ],
      },
    },
    'Madhya Pradesh': {
      'Agar Malwa': {

        'Agar Malwa City': [
          const VillageRecord(
            villageName: 'Agar Malwa Rural',
            lgdCode: '500910',
            gramPanchayat: 'Agar Malwa GP',
            policeStationPostOffice: 'Agar Malwa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Agar Malwa North',
            lgdCode: '500911',
            gramPanchayat: 'Agar Malwa Ward 1',
            policeStationPostOffice: 'Agar Malwa PS / PO',
          ),
        ],
        'Agar Malwa Block': [
          const VillageRecord(
            villageName: 'Agar Malwa East',
            lgdCode: '500912',
            gramPanchayat: 'Agar Malwa East GP',
            policeStationPostOffice: 'Agar Malwa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Agar Malwa South',
            lgdCode: '500913',
            gramPanchayat: 'Agar Malwa South GP',
            policeStationPostOffice: 'Agar Malwa Rural PS',
          ),
        ],
      },
      'Alirajpur': {

        'Alirajpur City': [
          const VillageRecord(
            villageName: 'Alirajpur Rural',
            lgdCode: '500914',
            gramPanchayat: 'Alirajpur GP',
            policeStationPostOffice: 'Alirajpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Alirajpur North',
            lgdCode: '500915',
            gramPanchayat: 'Alirajpur Ward 1',
            policeStationPostOffice: 'Alirajpur PS / PO',
          ),
        ],
        'Alirajpur Block': [
          const VillageRecord(
            villageName: 'Alirajpur East',
            lgdCode: '500916',
            gramPanchayat: 'Alirajpur East GP',
            policeStationPostOffice: 'Alirajpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Alirajpur South',
            lgdCode: '500917',
            gramPanchayat: 'Alirajpur South GP',
            policeStationPostOffice: 'Alirajpur Rural PS',
          ),
        ],
      },
      'Anuppur': {

        'Anuppur City': [
          const VillageRecord(
            villageName: 'Anuppur Rural',
            lgdCode: '500918',
            gramPanchayat: 'Anuppur GP',
            policeStationPostOffice: 'Anuppur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Anuppur North',
            lgdCode: '500919',
            gramPanchayat: 'Anuppur Ward 1',
            policeStationPostOffice: 'Anuppur PS / PO',
          ),
        ],
        'Anuppur Block': [
          const VillageRecord(
            villageName: 'Anuppur East',
            lgdCode: '500920',
            gramPanchayat: 'Anuppur East GP',
            policeStationPostOffice: 'Anuppur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Anuppur South',
            lgdCode: '500921',
            gramPanchayat: 'Anuppur South GP',
            policeStationPostOffice: 'Anuppur Rural PS',
          ),
        ],
      },
      'Ashoknagar': {

        'Ashoknagar City': [
          const VillageRecord(
            villageName: 'Ashoknagar Rural',
            lgdCode: '500922',
            gramPanchayat: 'Ashoknagar GP',
            policeStationPostOffice: 'Ashoknagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ashoknagar North',
            lgdCode: '500923',
            gramPanchayat: 'Ashoknagar Ward 1',
            policeStationPostOffice: 'Ashoknagar PS / PO',
          ),
        ],
        'Ashoknagar Block': [
          const VillageRecord(
            villageName: 'Ashoknagar East',
            lgdCode: '500924',
            gramPanchayat: 'Ashoknagar East GP',
            policeStationPostOffice: 'Ashoknagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ashoknagar South',
            lgdCode: '500925',
            gramPanchayat: 'Ashoknagar South GP',
            policeStationPostOffice: 'Ashoknagar Rural PS',
          ),
        ],
      },
      'Balaghat': {

        'Balaghat City': [
          const VillageRecord(
            villageName: 'Balaghat Rural',
            lgdCode: '500926',
            gramPanchayat: 'Balaghat GP',
            policeStationPostOffice: 'Balaghat PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balaghat North',
            lgdCode: '500927',
            gramPanchayat: 'Balaghat Ward 1',
            policeStationPostOffice: 'Balaghat PS / PO',
          ),
        ],
        'Balaghat Block': [
          const VillageRecord(
            villageName: 'Balaghat East',
            lgdCode: '500928',
            gramPanchayat: 'Balaghat East GP',
            policeStationPostOffice: 'Balaghat Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balaghat South',
            lgdCode: '500929',
            gramPanchayat: 'Balaghat South GP',
            policeStationPostOffice: 'Balaghat Rural PS',
          ),
        ],
      },
      'Barwani': {

        'Barwani City': [
          const VillageRecord(
            villageName: 'Barwani Rural',
            lgdCode: '500930',
            gramPanchayat: 'Barwani GP',
            policeStationPostOffice: 'Barwani PS / PO',
          ),
          const VillageRecord(
            villageName: 'Barwani North',
            lgdCode: '500931',
            gramPanchayat: 'Barwani Ward 1',
            policeStationPostOffice: 'Barwani PS / PO',
          ),
        ],
        'Barwani Block': [
          const VillageRecord(
            villageName: 'Barwani East',
            lgdCode: '500932',
            gramPanchayat: 'Barwani East GP',
            policeStationPostOffice: 'Barwani Rural PS',
          ),
          const VillageRecord(
            villageName: 'Barwani South',
            lgdCode: '500933',
            gramPanchayat: 'Barwani South GP',
            policeStationPostOffice: 'Barwani Rural PS',
          ),
        ],
      },
      'Betul': {

        'Betul City': [
          const VillageRecord(
            villageName: 'Betul Rural',
            lgdCode: '500934',
            gramPanchayat: 'Betul GP',
            policeStationPostOffice: 'Betul PS / PO',
          ),
          const VillageRecord(
            villageName: 'Betul North',
            lgdCode: '500935',
            gramPanchayat: 'Betul Ward 1',
            policeStationPostOffice: 'Betul PS / PO',
          ),
        ],
        'Betul Block': [
          const VillageRecord(
            villageName: 'Betul East',
            lgdCode: '500936',
            gramPanchayat: 'Betul East GP',
            policeStationPostOffice: 'Betul Rural PS',
          ),
          const VillageRecord(
            villageName: 'Betul South',
            lgdCode: '500937',
            gramPanchayat: 'Betul South GP',
            policeStationPostOffice: 'Betul Rural PS',
          ),
        ],
      },
      'Bhind': {

        'Bhind City': [
          const VillageRecord(
            villageName: 'Bhind Rural',
            lgdCode: '500938',
            gramPanchayat: 'Bhind GP',
            policeStationPostOffice: 'Bhind PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhind North',
            lgdCode: '500939',
            gramPanchayat: 'Bhind Ward 1',
            policeStationPostOffice: 'Bhind PS / PO',
          ),
        ],
        'Bhind Block': [
          const VillageRecord(
            villageName: 'Bhind East',
            lgdCode: '500940',
            gramPanchayat: 'Bhind East GP',
            policeStationPostOffice: 'Bhind Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhind South',
            lgdCode: '500941',
            gramPanchayat: 'Bhind South GP',
            policeStationPostOffice: 'Bhind Rural PS',
          ),
        ],
      },
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
      'Burhanpur': {

        'Burhanpur City': [
          const VillageRecord(
            villageName: 'Burhanpur Rural',
            lgdCode: '500942',
            gramPanchayat: 'Burhanpur GP',
            policeStationPostOffice: 'Burhanpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Burhanpur North',
            lgdCode: '500943',
            gramPanchayat: 'Burhanpur Ward 1',
            policeStationPostOffice: 'Burhanpur PS / PO',
          ),
        ],
        'Burhanpur Block': [
          const VillageRecord(
            villageName: 'Burhanpur East',
            lgdCode: '500944',
            gramPanchayat: 'Burhanpur East GP',
            policeStationPostOffice: 'Burhanpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Burhanpur South',
            lgdCode: '500945',
            gramPanchayat: 'Burhanpur South GP',
            policeStationPostOffice: 'Burhanpur Rural PS',
          ),
        ],
      },
      'Chhatarpur': {

        'Chhatarpur City': [
          const VillageRecord(
            villageName: 'Chhatarpur Rural',
            lgdCode: '500946',
            gramPanchayat: 'Chhatarpur GP',
            policeStationPostOffice: 'Chhatarpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chhatarpur North',
            lgdCode: '500947',
            gramPanchayat: 'Chhatarpur Ward 1',
            policeStationPostOffice: 'Chhatarpur PS / PO',
          ),
        ],
        'Chhatarpur Block': [
          const VillageRecord(
            villageName: 'Chhatarpur East',
            lgdCode: '500948',
            gramPanchayat: 'Chhatarpur East GP',
            policeStationPostOffice: 'Chhatarpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chhatarpur South',
            lgdCode: '500949',
            gramPanchayat: 'Chhatarpur South GP',
            policeStationPostOffice: 'Chhatarpur Rural PS',
          ),
        ],
      },
      'Chhindwara': {

        'Chhindwara City': [
          const VillageRecord(
            villageName: 'Chhindwara Rural',
            lgdCode: '500950',
            gramPanchayat: 'Chhindwara GP',
            policeStationPostOffice: 'Chhindwara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chhindwara North',
            lgdCode: '500951',
            gramPanchayat: 'Chhindwara Ward 1',
            policeStationPostOffice: 'Chhindwara PS / PO',
          ),
        ],
        'Chhindwara Block': [
          const VillageRecord(
            villageName: 'Chhindwara East',
            lgdCode: '500952',
            gramPanchayat: 'Chhindwara East GP',
            policeStationPostOffice: 'Chhindwara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chhindwara South',
            lgdCode: '500953',
            gramPanchayat: 'Chhindwara South GP',
            policeStationPostOffice: 'Chhindwara Rural PS',
          ),
        ],
      },
      'Damoh': {

        'Damoh City': [
          const VillageRecord(
            villageName: 'Damoh Rural',
            lgdCode: '500954',
            gramPanchayat: 'Damoh GP',
            policeStationPostOffice: 'Damoh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Damoh North',
            lgdCode: '500955',
            gramPanchayat: 'Damoh Ward 1',
            policeStationPostOffice: 'Damoh PS / PO',
          ),
        ],
        'Damoh Block': [
          const VillageRecord(
            villageName: 'Damoh East',
            lgdCode: '500956',
            gramPanchayat: 'Damoh East GP',
            policeStationPostOffice: 'Damoh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Damoh South',
            lgdCode: '500957',
            gramPanchayat: 'Damoh South GP',
            policeStationPostOffice: 'Damoh Rural PS',
          ),
        ],
      },
      'Datia': {

        'Datia City': [
          const VillageRecord(
            villageName: 'Datia Rural',
            lgdCode: '500958',
            gramPanchayat: 'Datia GP',
            policeStationPostOffice: 'Datia PS / PO',
          ),
          const VillageRecord(
            villageName: 'Datia North',
            lgdCode: '500959',
            gramPanchayat: 'Datia Ward 1',
            policeStationPostOffice: 'Datia PS / PO',
          ),
        ],
        'Datia Block': [
          const VillageRecord(
            villageName: 'Datia East',
            lgdCode: '500960',
            gramPanchayat: 'Datia East GP',
            policeStationPostOffice: 'Datia Rural PS',
          ),
          const VillageRecord(
            villageName: 'Datia South',
            lgdCode: '500961',
            gramPanchayat: 'Datia South GP',
            policeStationPostOffice: 'Datia Rural PS',
          ),
        ],
      },
      'Dewas': {

        'Dewas City': [
          const VillageRecord(
            villageName: 'Dewas Rural',
            lgdCode: '500962',
            gramPanchayat: 'Dewas GP',
            policeStationPostOffice: 'Dewas PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dewas North',
            lgdCode: '500963',
            gramPanchayat: 'Dewas Ward 1',
            policeStationPostOffice: 'Dewas PS / PO',
          ),
        ],
        'Dewas Block': [
          const VillageRecord(
            villageName: 'Dewas East',
            lgdCode: '500964',
            gramPanchayat: 'Dewas East GP',
            policeStationPostOffice: 'Dewas Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dewas South',
            lgdCode: '500965',
            gramPanchayat: 'Dewas South GP',
            policeStationPostOffice: 'Dewas Rural PS',
          ),
        ],
      },
      'Dhar': {

        'Dhar City': [
          const VillageRecord(
            villageName: 'Dhar Rural',
            lgdCode: '500966',
            gramPanchayat: 'Dhar GP',
            policeStationPostOffice: 'Dhar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dhar North',
            lgdCode: '500967',
            gramPanchayat: 'Dhar Ward 1',
            policeStationPostOffice: 'Dhar PS / PO',
          ),
        ],
        'Dhar Block': [
          const VillageRecord(
            villageName: 'Dhar East',
            lgdCode: '500968',
            gramPanchayat: 'Dhar East GP',
            policeStationPostOffice: 'Dhar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dhar South',
            lgdCode: '500969',
            gramPanchayat: 'Dhar South GP',
            policeStationPostOffice: 'Dhar Rural PS',
          ),
        ],
      },
      'Dindori': {

        'Dindori City': [
          const VillageRecord(
            villageName: 'Dindori Rural',
            lgdCode: '500970',
            gramPanchayat: 'Dindori GP',
            policeStationPostOffice: 'Dindori PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dindori North',
            lgdCode: '500971',
            gramPanchayat: 'Dindori Ward 1',
            policeStationPostOffice: 'Dindori PS / PO',
          ),
        ],
        'Dindori Block': [
          const VillageRecord(
            villageName: 'Dindori East',
            lgdCode: '500972',
            gramPanchayat: 'Dindori East GP',
            policeStationPostOffice: 'Dindori Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dindori South',
            lgdCode: '500973',
            gramPanchayat: 'Dindori South GP',
            policeStationPostOffice: 'Dindori Rural PS',
          ),
        ],
      },
      'Guna': {

        'Guna City': [
          const VillageRecord(
            villageName: 'Guna Rural',
            lgdCode: '500974',
            gramPanchayat: 'Guna GP',
            policeStationPostOffice: 'Guna PS / PO',
          ),
          const VillageRecord(
            villageName: 'Guna North',
            lgdCode: '500975',
            gramPanchayat: 'Guna Ward 1',
            policeStationPostOffice: 'Guna PS / PO',
          ),
        ],
        'Guna Block': [
          const VillageRecord(
            villageName: 'Guna East',
            lgdCode: '500976',
            gramPanchayat: 'Guna East GP',
            policeStationPostOffice: 'Guna Rural PS',
          ),
          const VillageRecord(
            villageName: 'Guna South',
            lgdCode: '500977',
            gramPanchayat: 'Guna South GP',
            policeStationPostOffice: 'Guna Rural PS',
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
      'Harda': {

        'Harda City': [
          const VillageRecord(
            villageName: 'Harda Rural',
            lgdCode: '500978',
            gramPanchayat: 'Harda GP',
            policeStationPostOffice: 'Harda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Harda North',
            lgdCode: '500979',
            gramPanchayat: 'Harda Ward 1',
            policeStationPostOffice: 'Harda PS / PO',
          ),
        ],
        'Harda Block': [
          const VillageRecord(
            villageName: 'Harda East',
            lgdCode: '500980',
            gramPanchayat: 'Harda East GP',
            policeStationPostOffice: 'Harda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Harda South',
            lgdCode: '500981',
            gramPanchayat: 'Harda South GP',
            policeStationPostOffice: 'Harda Rural PS',
          ),
        ],
      },
      'Hoshangabad': {

        'Hoshangabad City': [
          const VillageRecord(
            villageName: 'Hoshangabad Rural',
            lgdCode: '500982',
            gramPanchayat: 'Hoshangabad GP',
            policeStationPostOffice: 'Hoshangabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hoshangabad North',
            lgdCode: '500983',
            gramPanchayat: 'Hoshangabad Ward 1',
            policeStationPostOffice: 'Hoshangabad PS / PO',
          ),
        ],
        'Hoshangabad Block': [
          const VillageRecord(
            villageName: 'Hoshangabad East',
            lgdCode: '500984',
            gramPanchayat: 'Hoshangabad East GP',
            policeStationPostOffice: 'Hoshangabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hoshangabad South',
            lgdCode: '500985',
            gramPanchayat: 'Hoshangabad South GP',
            policeStationPostOffice: 'Hoshangabad Rural PS',
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
      'Jhabua': {

        'Jhabua City': [
          const VillageRecord(
            villageName: 'Jhabua Rural',
            lgdCode: '500986',
            gramPanchayat: 'Jhabua GP',
            policeStationPostOffice: 'Jhabua PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jhabua North',
            lgdCode: '500987',
            gramPanchayat: 'Jhabua Ward 1',
            policeStationPostOffice: 'Jhabua PS / PO',
          ),
        ],
        'Jhabua Block': [
          const VillageRecord(
            villageName: 'Jhabua East',
            lgdCode: '500988',
            gramPanchayat: 'Jhabua East GP',
            policeStationPostOffice: 'Jhabua Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jhabua South',
            lgdCode: '500989',
            gramPanchayat: 'Jhabua South GP',
            policeStationPostOffice: 'Jhabua Rural PS',
          ),
        ],
      },
      'Katni': {

        'Katni City': [
          const VillageRecord(
            villageName: 'Katni Rural',
            lgdCode: '500990',
            gramPanchayat: 'Katni GP',
            policeStationPostOffice: 'Katni PS / PO',
          ),
          const VillageRecord(
            villageName: 'Katni North',
            lgdCode: '500991',
            gramPanchayat: 'Katni Ward 1',
            policeStationPostOffice: 'Katni PS / PO',
          ),
        ],
        'Katni Block': [
          const VillageRecord(
            villageName: 'Katni East',
            lgdCode: '500992',
            gramPanchayat: 'Katni East GP',
            policeStationPostOffice: 'Katni Rural PS',
          ),
          const VillageRecord(
            villageName: 'Katni South',
            lgdCode: '500993',
            gramPanchayat: 'Katni South GP',
            policeStationPostOffice: 'Katni Rural PS',
          ),
        ],
      },
      'Khandwa': {

        'Khandwa City': [
          const VillageRecord(
            villageName: 'Khandwa Rural',
            lgdCode: '500994',
            gramPanchayat: 'Khandwa GP',
            policeStationPostOffice: 'Khandwa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khandwa North',
            lgdCode: '500995',
            gramPanchayat: 'Khandwa Ward 1',
            policeStationPostOffice: 'Khandwa PS / PO',
          ),
        ],
        'Khandwa Block': [
          const VillageRecord(
            villageName: 'Khandwa East',
            lgdCode: '500996',
            gramPanchayat: 'Khandwa East GP',
            policeStationPostOffice: 'Khandwa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khandwa South',
            lgdCode: '500997',
            gramPanchayat: 'Khandwa South GP',
            policeStationPostOffice: 'Khandwa Rural PS',
          ),
        ],
      },
      'Khargone': {

        'Khargone City': [
          const VillageRecord(
            villageName: 'Khargone Rural',
            lgdCode: '500998',
            gramPanchayat: 'Khargone GP',
            policeStationPostOffice: 'Khargone PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khargone North',
            lgdCode: '500999',
            gramPanchayat: 'Khargone Ward 1',
            policeStationPostOffice: 'Khargone PS / PO',
          ),
        ],
        'Khargone Block': [
          const VillageRecord(
            villageName: 'Khargone East',
            lgdCode: '501000',
            gramPanchayat: 'Khargone East GP',
            policeStationPostOffice: 'Khargone Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khargone South',
            lgdCode: '501001',
            gramPanchayat: 'Khargone South GP',
            policeStationPostOffice: 'Khargone Rural PS',
          ),
        ],
      },
      'Mandla': {

        'Mandla City': [
          const VillageRecord(
            villageName: 'Mandla Rural',
            lgdCode: '501002',
            gramPanchayat: 'Mandla GP',
            policeStationPostOffice: 'Mandla PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mandla North',
            lgdCode: '501003',
            gramPanchayat: 'Mandla Ward 1',
            policeStationPostOffice: 'Mandla PS / PO',
          ),
        ],
        'Mandla Block': [
          const VillageRecord(
            villageName: 'Mandla East',
            lgdCode: '501004',
            gramPanchayat: 'Mandla East GP',
            policeStationPostOffice: 'Mandla Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mandla South',
            lgdCode: '501005',
            gramPanchayat: 'Mandla South GP',
            policeStationPostOffice: 'Mandla Rural PS',
          ),
        ],
      },
      'Mandsaur': {

        'Mandsaur City': [
          const VillageRecord(
            villageName: 'Mandsaur Rural',
            lgdCode: '501006',
            gramPanchayat: 'Mandsaur GP',
            policeStationPostOffice: 'Mandsaur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mandsaur North',
            lgdCode: '501007',
            gramPanchayat: 'Mandsaur Ward 1',
            policeStationPostOffice: 'Mandsaur PS / PO',
          ),
        ],
        'Mandsaur Block': [
          const VillageRecord(
            villageName: 'Mandsaur East',
            lgdCode: '501008',
            gramPanchayat: 'Mandsaur East GP',
            policeStationPostOffice: 'Mandsaur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mandsaur South',
            lgdCode: '501009',
            gramPanchayat: 'Mandsaur South GP',
            policeStationPostOffice: 'Mandsaur Rural PS',
          ),
        ],
      },
      'Morena': {

        'Morena City': [
          const VillageRecord(
            villageName: 'Morena Rural',
            lgdCode: '501010',
            gramPanchayat: 'Morena GP',
            policeStationPostOffice: 'Morena PS / PO',
          ),
          const VillageRecord(
            villageName: 'Morena North',
            lgdCode: '501011',
            gramPanchayat: 'Morena Ward 1',
            policeStationPostOffice: 'Morena PS / PO',
          ),
        ],
        'Morena Block': [
          const VillageRecord(
            villageName: 'Morena East',
            lgdCode: '501012',
            gramPanchayat: 'Morena East GP',
            policeStationPostOffice: 'Morena Rural PS',
          ),
          const VillageRecord(
            villageName: 'Morena South',
            lgdCode: '501013',
            gramPanchayat: 'Morena South GP',
            policeStationPostOffice: 'Morena Rural PS',
          ),
        ],
      },
      'Narsinghpur': {

        'Narsinghpur City': [
          const VillageRecord(
            villageName: 'Narsinghpur Rural',
            lgdCode: '501014',
            gramPanchayat: 'Narsinghpur GP',
            policeStationPostOffice: 'Narsinghpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Narsinghpur North',
            lgdCode: '501015',
            gramPanchayat: 'Narsinghpur Ward 1',
            policeStationPostOffice: 'Narsinghpur PS / PO',
          ),
        ],
        'Narsinghpur Block': [
          const VillageRecord(
            villageName: 'Narsinghpur East',
            lgdCode: '501016',
            gramPanchayat: 'Narsinghpur East GP',
            policeStationPostOffice: 'Narsinghpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Narsinghpur South',
            lgdCode: '501017',
            gramPanchayat: 'Narsinghpur South GP',
            policeStationPostOffice: 'Narsinghpur Rural PS',
          ),
        ],
      },
      'Neemuch': {

        'Neemuch City': [
          const VillageRecord(
            villageName: 'Neemuch Rural',
            lgdCode: '501018',
            gramPanchayat: 'Neemuch GP',
            policeStationPostOffice: 'Neemuch PS / PO',
          ),
          const VillageRecord(
            villageName: 'Neemuch North',
            lgdCode: '501019',
            gramPanchayat: 'Neemuch Ward 1',
            policeStationPostOffice: 'Neemuch PS / PO',
          ),
        ],
        'Neemuch Block': [
          const VillageRecord(
            villageName: 'Neemuch East',
            lgdCode: '501020',
            gramPanchayat: 'Neemuch East GP',
            policeStationPostOffice: 'Neemuch Rural PS',
          ),
          const VillageRecord(
            villageName: 'Neemuch South',
            lgdCode: '501021',
            gramPanchayat: 'Neemuch South GP',
            policeStationPostOffice: 'Neemuch Rural PS',
          ),
        ],
      },
      'Niwari': {

        'Niwari City': [
          const VillageRecord(
            villageName: 'Niwari Rural',
            lgdCode: '501022',
            gramPanchayat: 'Niwari GP',
            policeStationPostOffice: 'Niwari PS / PO',
          ),
          const VillageRecord(
            villageName: 'Niwari North',
            lgdCode: '501023',
            gramPanchayat: 'Niwari Ward 1',
            policeStationPostOffice: 'Niwari PS / PO',
          ),
        ],
        'Niwari Block': [
          const VillageRecord(
            villageName: 'Niwari East',
            lgdCode: '501024',
            gramPanchayat: 'Niwari East GP',
            policeStationPostOffice: 'Niwari Rural PS',
          ),
          const VillageRecord(
            villageName: 'Niwari South',
            lgdCode: '501025',
            gramPanchayat: 'Niwari South GP',
            policeStationPostOffice: 'Niwari Rural PS',
          ),
        ],
      },
      'Panna': {

        'Panna City': [
          const VillageRecord(
            villageName: 'Panna Rural',
            lgdCode: '501026',
            gramPanchayat: 'Panna GP',
            policeStationPostOffice: 'Panna PS / PO',
          ),
          const VillageRecord(
            villageName: 'Panna North',
            lgdCode: '501027',
            gramPanchayat: 'Panna Ward 1',
            policeStationPostOffice: 'Panna PS / PO',
          ),
        ],
        'Panna Block': [
          const VillageRecord(
            villageName: 'Panna East',
            lgdCode: '501028',
            gramPanchayat: 'Panna East GP',
            policeStationPostOffice: 'Panna Rural PS',
          ),
          const VillageRecord(
            villageName: 'Panna South',
            lgdCode: '501029',
            gramPanchayat: 'Panna South GP',
            policeStationPostOffice: 'Panna Rural PS',
          ),
        ],
      },
      'Raisen': {

        'Raisen City': [
          const VillageRecord(
            villageName: 'Raisen Rural',
            lgdCode: '501030',
            gramPanchayat: 'Raisen GP',
            policeStationPostOffice: 'Raisen PS / PO',
          ),
          const VillageRecord(
            villageName: 'Raisen North',
            lgdCode: '501031',
            gramPanchayat: 'Raisen Ward 1',
            policeStationPostOffice: 'Raisen PS / PO',
          ),
        ],
        'Raisen Block': [
          const VillageRecord(
            villageName: 'Raisen East',
            lgdCode: '501032',
            gramPanchayat: 'Raisen East GP',
            policeStationPostOffice: 'Raisen Rural PS',
          ),
          const VillageRecord(
            villageName: 'Raisen South',
            lgdCode: '501033',
            gramPanchayat: 'Raisen South GP',
            policeStationPostOffice: 'Raisen Rural PS',
          ),
        ],
      },
      'Rajgarh': {

        'Rajgarh City': [
          const VillageRecord(
            villageName: 'Rajgarh Rural',
            lgdCode: '501034',
            gramPanchayat: 'Rajgarh GP',
            policeStationPostOffice: 'Rajgarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rajgarh North',
            lgdCode: '501035',
            gramPanchayat: 'Rajgarh Ward 1',
            policeStationPostOffice: 'Rajgarh PS / PO',
          ),
        ],
        'Rajgarh Block': [
          const VillageRecord(
            villageName: 'Rajgarh East',
            lgdCode: '501036',
            gramPanchayat: 'Rajgarh East GP',
            policeStationPostOffice: 'Rajgarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rajgarh South',
            lgdCode: '501037',
            gramPanchayat: 'Rajgarh South GP',
            policeStationPostOffice: 'Rajgarh Rural PS',
          ),
        ],
      },
      'Ratlam': {

        'Ratlam City': [
          const VillageRecord(
            villageName: 'Ratlam Rural',
            lgdCode: '501038',
            gramPanchayat: 'Ratlam GP',
            policeStationPostOffice: 'Ratlam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ratlam North',
            lgdCode: '501039',
            gramPanchayat: 'Ratlam Ward 1',
            policeStationPostOffice: 'Ratlam PS / PO',
          ),
        ],
        'Ratlam Block': [
          const VillageRecord(
            villageName: 'Ratlam East',
            lgdCode: '501040',
            gramPanchayat: 'Ratlam East GP',
            policeStationPostOffice: 'Ratlam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ratlam South',
            lgdCode: '501041',
            gramPanchayat: 'Ratlam South GP',
            policeStationPostOffice: 'Ratlam Rural PS',
          ),
        ],
      },
      'Rewa': {

        'Rewa City': [
          const VillageRecord(
            villageName: 'Rewa Rural',
            lgdCode: '501042',
            gramPanchayat: 'Rewa GP',
            policeStationPostOffice: 'Rewa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rewa North',
            lgdCode: '501043',
            gramPanchayat: 'Rewa Ward 1',
            policeStationPostOffice: 'Rewa PS / PO',
          ),
        ],
        'Rewa Block': [
          const VillageRecord(
            villageName: 'Rewa East',
            lgdCode: '501044',
            gramPanchayat: 'Rewa East GP',
            policeStationPostOffice: 'Rewa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rewa South',
            lgdCode: '501045',
            gramPanchayat: 'Rewa South GP',
            policeStationPostOffice: 'Rewa Rural PS',
          ),
        ],
      },
      'Sagar': {

        'Sagar City': [
          const VillageRecord(
            villageName: 'Sagar Rural',
            lgdCode: '501046',
            gramPanchayat: 'Sagar GP',
            policeStationPostOffice: 'Sagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sagar North',
            lgdCode: '501047',
            gramPanchayat: 'Sagar Ward 1',
            policeStationPostOffice: 'Sagar PS / PO',
          ),
        ],
        'Sagar Block': [
          const VillageRecord(
            villageName: 'Sagar East',
            lgdCode: '501048',
            gramPanchayat: 'Sagar East GP',
            policeStationPostOffice: 'Sagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sagar South',
            lgdCode: '501049',
            gramPanchayat: 'Sagar South GP',
            policeStationPostOffice: 'Sagar Rural PS',
          ),
        ],
      },
      'Satna': {

        'Satna City': [
          const VillageRecord(
            villageName: 'Satna Rural',
            lgdCode: '501050',
            gramPanchayat: 'Satna GP',
            policeStationPostOffice: 'Satna PS / PO',
          ),
          const VillageRecord(
            villageName: 'Satna North',
            lgdCode: '501051',
            gramPanchayat: 'Satna Ward 1',
            policeStationPostOffice: 'Satna PS / PO',
          ),
        ],
        'Satna Block': [
          const VillageRecord(
            villageName: 'Satna East',
            lgdCode: '501052',
            gramPanchayat: 'Satna East GP',
            policeStationPostOffice: 'Satna Rural PS',
          ),
          const VillageRecord(
            villageName: 'Satna South',
            lgdCode: '501053',
            gramPanchayat: 'Satna South GP',
            policeStationPostOffice: 'Satna Rural PS',
          ),
        ],
      },
      'Sehore': {

        'Sehore City': [
          const VillageRecord(
            villageName: 'Sehore Rural',
            lgdCode: '501054',
            gramPanchayat: 'Sehore GP',
            policeStationPostOffice: 'Sehore PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sehore North',
            lgdCode: '501055',
            gramPanchayat: 'Sehore Ward 1',
            policeStationPostOffice: 'Sehore PS / PO',
          ),
        ],
        'Sehore Block': [
          const VillageRecord(
            villageName: 'Sehore East',
            lgdCode: '501056',
            gramPanchayat: 'Sehore East GP',
            policeStationPostOffice: 'Sehore Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sehore South',
            lgdCode: '501057',
            gramPanchayat: 'Sehore South GP',
            policeStationPostOffice: 'Sehore Rural PS',
          ),
        ],
      },
      'Seoni': {

        'Seoni City': [
          const VillageRecord(
            villageName: 'Seoni Rural',
            lgdCode: '501058',
            gramPanchayat: 'Seoni GP',
            policeStationPostOffice: 'Seoni PS / PO',
          ),
          const VillageRecord(
            villageName: 'Seoni North',
            lgdCode: '501059',
            gramPanchayat: 'Seoni Ward 1',
            policeStationPostOffice: 'Seoni PS / PO',
          ),
        ],
        'Seoni Block': [
          const VillageRecord(
            villageName: 'Seoni East',
            lgdCode: '501060',
            gramPanchayat: 'Seoni East GP',
            policeStationPostOffice: 'Seoni Rural PS',
          ),
          const VillageRecord(
            villageName: 'Seoni South',
            lgdCode: '501061',
            gramPanchayat: 'Seoni South GP',
            policeStationPostOffice: 'Seoni Rural PS',
          ),
        ],
      },
      'Shahdol': {

        'Shahdol City': [
          const VillageRecord(
            villageName: 'Shahdol Rural',
            lgdCode: '501062',
            gramPanchayat: 'Shahdol GP',
            policeStationPostOffice: 'Shahdol PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shahdol North',
            lgdCode: '501063',
            gramPanchayat: 'Shahdol Ward 1',
            policeStationPostOffice: 'Shahdol PS / PO',
          ),
        ],
        'Shahdol Block': [
          const VillageRecord(
            villageName: 'Shahdol East',
            lgdCode: '501064',
            gramPanchayat: 'Shahdol East GP',
            policeStationPostOffice: 'Shahdol Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shahdol South',
            lgdCode: '501065',
            gramPanchayat: 'Shahdol South GP',
            policeStationPostOffice: 'Shahdol Rural PS',
          ),
        ],
      },
      'Shajapur': {

        'Shajapur City': [
          const VillageRecord(
            villageName: 'Shajapur Rural',
            lgdCode: '501066',
            gramPanchayat: 'Shajapur GP',
            policeStationPostOffice: 'Shajapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shajapur North',
            lgdCode: '501067',
            gramPanchayat: 'Shajapur Ward 1',
            policeStationPostOffice: 'Shajapur PS / PO',
          ),
        ],
        'Shajapur Block': [
          const VillageRecord(
            villageName: 'Shajapur East',
            lgdCode: '501068',
            gramPanchayat: 'Shajapur East GP',
            policeStationPostOffice: 'Shajapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shajapur South',
            lgdCode: '501069',
            gramPanchayat: 'Shajapur South GP',
            policeStationPostOffice: 'Shajapur Rural PS',
          ),
        ],
      },
      'Sheopur': {

        'Sheopur City': [
          const VillageRecord(
            villageName: 'Sheopur Rural',
            lgdCode: '501070',
            gramPanchayat: 'Sheopur GP',
            policeStationPostOffice: 'Sheopur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sheopur North',
            lgdCode: '501071',
            gramPanchayat: 'Sheopur Ward 1',
            policeStationPostOffice: 'Sheopur PS / PO',
          ),
        ],
        'Sheopur Block': [
          const VillageRecord(
            villageName: 'Sheopur East',
            lgdCode: '501072',
            gramPanchayat: 'Sheopur East GP',
            policeStationPostOffice: 'Sheopur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sheopur South',
            lgdCode: '501073',
            gramPanchayat: 'Sheopur South GP',
            policeStationPostOffice: 'Sheopur Rural PS',
          ),
        ],
      },
      'Shivpuri': {

        'Shivpuri City': [
          const VillageRecord(
            villageName: 'Shivpuri Rural',
            lgdCode: '501074',
            gramPanchayat: 'Shivpuri GP',
            policeStationPostOffice: 'Shivpuri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shivpuri North',
            lgdCode: '501075',
            gramPanchayat: 'Shivpuri Ward 1',
            policeStationPostOffice: 'Shivpuri PS / PO',
          ),
        ],
        'Shivpuri Block': [
          const VillageRecord(
            villageName: 'Shivpuri East',
            lgdCode: '501076',
            gramPanchayat: 'Shivpuri East GP',
            policeStationPostOffice: 'Shivpuri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shivpuri South',
            lgdCode: '501077',
            gramPanchayat: 'Shivpuri South GP',
            policeStationPostOffice: 'Shivpuri Rural PS',
          ),
        ],
      },
      'Sidhi': {

        'Sidhi City': [
          const VillageRecord(
            villageName: 'Sidhi Rural',
            lgdCode: '501078',
            gramPanchayat: 'Sidhi GP',
            policeStationPostOffice: 'Sidhi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sidhi North',
            lgdCode: '501079',
            gramPanchayat: 'Sidhi Ward 1',
            policeStationPostOffice: 'Sidhi PS / PO',
          ),
        ],
        'Sidhi Block': [
          const VillageRecord(
            villageName: 'Sidhi East',
            lgdCode: '501080',
            gramPanchayat: 'Sidhi East GP',
            policeStationPostOffice: 'Sidhi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sidhi South',
            lgdCode: '501081',
            gramPanchayat: 'Sidhi South GP',
            policeStationPostOffice: 'Sidhi Rural PS',
          ),
        ],
      },
      'Singrauli': {

        'Singrauli City': [
          const VillageRecord(
            villageName: 'Singrauli Rural',
            lgdCode: '501082',
            gramPanchayat: 'Singrauli GP',
            policeStationPostOffice: 'Singrauli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Singrauli North',
            lgdCode: '501083',
            gramPanchayat: 'Singrauli Ward 1',
            policeStationPostOffice: 'Singrauli PS / PO',
          ),
        ],
        'Singrauli Block': [
          const VillageRecord(
            villageName: 'Singrauli East',
            lgdCode: '501084',
            gramPanchayat: 'Singrauli East GP',
            policeStationPostOffice: 'Singrauli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Singrauli South',
            lgdCode: '501085',
            gramPanchayat: 'Singrauli South GP',
            policeStationPostOffice: 'Singrauli Rural PS',
          ),
        ],
      },
      'Tikamgarh': {

        'Tikamgarh City': [
          const VillageRecord(
            villageName: 'Tikamgarh Rural',
            lgdCode: '501086',
            gramPanchayat: 'Tikamgarh GP',
            policeStationPostOffice: 'Tikamgarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tikamgarh North',
            lgdCode: '501087',
            gramPanchayat: 'Tikamgarh Ward 1',
            policeStationPostOffice: 'Tikamgarh PS / PO',
          ),
        ],
        'Tikamgarh Block': [
          const VillageRecord(
            villageName: 'Tikamgarh East',
            lgdCode: '501088',
            gramPanchayat: 'Tikamgarh East GP',
            policeStationPostOffice: 'Tikamgarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tikamgarh South',
            lgdCode: '501089',
            gramPanchayat: 'Tikamgarh South GP',
            policeStationPostOffice: 'Tikamgarh Rural PS',
          ),
        ],
      },
      'Ujjain': {

        'Ujjain City': [
          const VillageRecord(
            villageName: 'Ujjain Rural',
            lgdCode: '501090',
            gramPanchayat: 'Ujjain GP',
            policeStationPostOffice: 'Ujjain PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ujjain North',
            lgdCode: '501091',
            gramPanchayat: 'Ujjain Ward 1',
            policeStationPostOffice: 'Ujjain PS / PO',
          ),
        ],
        'Ujjain Block': [
          const VillageRecord(
            villageName: 'Ujjain East',
            lgdCode: '501092',
            gramPanchayat: 'Ujjain East GP',
            policeStationPostOffice: 'Ujjain Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ujjain South',
            lgdCode: '501093',
            gramPanchayat: 'Ujjain South GP',
            policeStationPostOffice: 'Ujjain Rural PS',
          ),
        ],
      },
      'Umaria': {

        'Umaria City': [
          const VillageRecord(
            villageName: 'Umaria Rural',
            lgdCode: '501094',
            gramPanchayat: 'Umaria GP',
            policeStationPostOffice: 'Umaria PS / PO',
          ),
          const VillageRecord(
            villageName: 'Umaria North',
            lgdCode: '501095',
            gramPanchayat: 'Umaria Ward 1',
            policeStationPostOffice: 'Umaria PS / PO',
          ),
        ],
        'Umaria Block': [
          const VillageRecord(
            villageName: 'Umaria East',
            lgdCode: '501096',
            gramPanchayat: 'Umaria East GP',
            policeStationPostOffice: 'Umaria Rural PS',
          ),
          const VillageRecord(
            villageName: 'Umaria South',
            lgdCode: '501097',
            gramPanchayat: 'Umaria South GP',
            policeStationPostOffice: 'Umaria Rural PS',
          ),
        ],
      },
      'Vidisha': {

        'Vidisha City': [
          const VillageRecord(
            villageName: 'Vidisha Rural',
            lgdCode: '501098',
            gramPanchayat: 'Vidisha GP',
            policeStationPostOffice: 'Vidisha PS / PO',
          ),
          const VillageRecord(
            villageName: 'Vidisha North',
            lgdCode: '501099',
            gramPanchayat: 'Vidisha Ward 1',
            policeStationPostOffice: 'Vidisha PS / PO',
          ),
        ],
        'Vidisha Block': [
          const VillageRecord(
            villageName: 'Vidisha East',
            lgdCode: '501100',
            gramPanchayat: 'Vidisha East GP',
            policeStationPostOffice: 'Vidisha Rural PS',
          ),
          const VillageRecord(
            villageName: 'Vidisha South',
            lgdCode: '501101',
            gramPanchayat: 'Vidisha South GP',
            policeStationPostOffice: 'Vidisha Rural PS',
          ),
        ],
      },
      'Mauganj': {

        'Mauganj City': [
          const VillageRecord(
            villageName: 'Mauganj Rural',
            lgdCode: '501102',
            gramPanchayat: 'Mauganj GP',
            policeStationPostOffice: 'Mauganj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mauganj North',
            lgdCode: '501103',
            gramPanchayat: 'Mauganj Ward 1',
            policeStationPostOffice: 'Mauganj PS / PO',
          ),
        ],
        'Mauganj Block': [
          const VillageRecord(
            villageName: 'Mauganj East',
            lgdCode: '501104',
            gramPanchayat: 'Mauganj East GP',
            policeStationPostOffice: 'Mauganj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mauganj South',
            lgdCode: '501105',
            gramPanchayat: 'Mauganj South GP',
            policeStationPostOffice: 'Mauganj Rural PS',
          ),
        ],
      },
    },
    'Maharashtra': {
      'Ahmednagar': {

        'Ahmednagar City': [
          const VillageRecord(
            villageName: 'Ahmednagar Rural',
            lgdCode: '501106',
            gramPanchayat: 'Ahmednagar GP',
            policeStationPostOffice: 'Ahmednagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ahmednagar North',
            lgdCode: '501107',
            gramPanchayat: 'Ahmednagar Ward 1',
            policeStationPostOffice: 'Ahmednagar PS / PO',
          ),
        ],
        'Ahmednagar Block': [
          const VillageRecord(
            villageName: 'Ahmednagar East',
            lgdCode: '501108',
            gramPanchayat: 'Ahmednagar East GP',
            policeStationPostOffice: 'Ahmednagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ahmednagar South',
            lgdCode: '501109',
            gramPanchayat: 'Ahmednagar South GP',
            policeStationPostOffice: 'Ahmednagar Rural PS',
          ),
        ],
      },
      'Akola': {

        'Akola City': [
          const VillageRecord(
            villageName: 'Akola Rural',
            lgdCode: '501110',
            gramPanchayat: 'Akola GP',
            policeStationPostOffice: 'Akola PS / PO',
          ),
          const VillageRecord(
            villageName: 'Akola North',
            lgdCode: '501111',
            gramPanchayat: 'Akola Ward 1',
            policeStationPostOffice: 'Akola PS / PO',
          ),
        ],
        'Akola Block': [
          const VillageRecord(
            villageName: 'Akola East',
            lgdCode: '501112',
            gramPanchayat: 'Akola East GP',
            policeStationPostOffice: 'Akola Rural PS',
          ),
          const VillageRecord(
            villageName: 'Akola South',
            lgdCode: '501113',
            gramPanchayat: 'Akola South GP',
            policeStationPostOffice: 'Akola Rural PS',
          ),
        ],
      },
      'Amravati': {

        'Amravati City': [
          const VillageRecord(
            villageName: 'Amravati Rural',
            lgdCode: '501114',
            gramPanchayat: 'Amravati GP',
            policeStationPostOffice: 'Amravati PS / PO',
          ),
          const VillageRecord(
            villageName: 'Amravati North',
            lgdCode: '501115',
            gramPanchayat: 'Amravati Ward 1',
            policeStationPostOffice: 'Amravati PS / PO',
          ),
        ],
        'Amravati Block': [
          const VillageRecord(
            villageName: 'Amravati East',
            lgdCode: '501116',
            gramPanchayat: 'Amravati East GP',
            policeStationPostOffice: 'Amravati Rural PS',
          ),
          const VillageRecord(
            villageName: 'Amravati South',
            lgdCode: '501117',
            gramPanchayat: 'Amravati South GP',
            policeStationPostOffice: 'Amravati Rural PS',
          ),
        ],
      },
      'Chhatrapati Sambhajinagar': {

        'Chhatrapati Sambhajinagar City': [
          const VillageRecord(
            villageName: 'Chhatrapati Sambhajinagar Rural',
            lgdCode: '501118',
            gramPanchayat: 'Chhatrapati Sambhajinagar GP',
            policeStationPostOffice: 'Chhatrapati Sambhajinagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chhatrapati Sambhajinagar North',
            lgdCode: '501119',
            gramPanchayat: 'Chhatrapati Sambhajinagar Ward 1',
            policeStationPostOffice: 'Chhatrapati Sambhajinagar PS / PO',
          ),
        ],
        'Chhatrapati Sambhajinagar Block': [
          const VillageRecord(
            villageName: 'Chhatrapati Sambhajinagar East',
            lgdCode: '501120',
            gramPanchayat: 'Chhatrapati Sambhajinagar East GP',
            policeStationPostOffice: 'Chhatrapati Sambhajinagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chhatrapati Sambhajinagar South',
            lgdCode: '501121',
            gramPanchayat: 'Chhatrapati Sambhajinagar South GP',
            policeStationPostOffice: 'Chhatrapati Sambhajinagar Rural PS',
          ),
        ],
      },
      'Beed': {

        'Beed City': [
          const VillageRecord(
            villageName: 'Beed Rural',
            lgdCode: '501122',
            gramPanchayat: 'Beed GP',
            policeStationPostOffice: 'Beed PS / PO',
          ),
          const VillageRecord(
            villageName: 'Beed North',
            lgdCode: '501123',
            gramPanchayat: 'Beed Ward 1',
            policeStationPostOffice: 'Beed PS / PO',
          ),
        ],
        'Beed Block': [
          const VillageRecord(
            villageName: 'Beed East',
            lgdCode: '501124',
            gramPanchayat: 'Beed East GP',
            policeStationPostOffice: 'Beed Rural PS',
          ),
          const VillageRecord(
            villageName: 'Beed South',
            lgdCode: '501125',
            gramPanchayat: 'Beed South GP',
            policeStationPostOffice: 'Beed Rural PS',
          ),
        ],
      },
      'Bhandara': {

        'Bhandara City': [
          const VillageRecord(
            villageName: 'Bhandara Rural',
            lgdCode: '501126',
            gramPanchayat: 'Bhandara GP',
            policeStationPostOffice: 'Bhandara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhandara North',
            lgdCode: '501127',
            gramPanchayat: 'Bhandara Ward 1',
            policeStationPostOffice: 'Bhandara PS / PO',
          ),
        ],
        'Bhandara Block': [
          const VillageRecord(
            villageName: 'Bhandara East',
            lgdCode: '501128',
            gramPanchayat: 'Bhandara East GP',
            policeStationPostOffice: 'Bhandara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhandara South',
            lgdCode: '501129',
            gramPanchayat: 'Bhandara South GP',
            policeStationPostOffice: 'Bhandara Rural PS',
          ),
        ],
      },
      'Buldhana': {

        'Buldhana City': [
          const VillageRecord(
            villageName: 'Buldhana Rural',
            lgdCode: '501130',
            gramPanchayat: 'Buldhana GP',
            policeStationPostOffice: 'Buldhana PS / PO',
          ),
          const VillageRecord(
            villageName: 'Buldhana North',
            lgdCode: '501131',
            gramPanchayat: 'Buldhana Ward 1',
            policeStationPostOffice: 'Buldhana PS / PO',
          ),
        ],
        'Buldhana Block': [
          const VillageRecord(
            villageName: 'Buldhana East',
            lgdCode: '501132',
            gramPanchayat: 'Buldhana East GP',
            policeStationPostOffice: 'Buldhana Rural PS',
          ),
          const VillageRecord(
            villageName: 'Buldhana South',
            lgdCode: '501133',
            gramPanchayat: 'Buldhana South GP',
            policeStationPostOffice: 'Buldhana Rural PS',
          ),
        ],
      },
      'Chandrapur': {

        'Chandrapur City': [
          const VillageRecord(
            villageName: 'Chandrapur Rural',
            lgdCode: '501134',
            gramPanchayat: 'Chandrapur GP',
            policeStationPostOffice: 'Chandrapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chandrapur North',
            lgdCode: '501135',
            gramPanchayat: 'Chandrapur Ward 1',
            policeStationPostOffice: 'Chandrapur PS / PO',
          ),
        ],
        'Chandrapur Block': [
          const VillageRecord(
            villageName: 'Chandrapur East',
            lgdCode: '501136',
            gramPanchayat: 'Chandrapur East GP',
            policeStationPostOffice: 'Chandrapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chandrapur South',
            lgdCode: '501137',
            gramPanchayat: 'Chandrapur South GP',
            policeStationPostOffice: 'Chandrapur Rural PS',
          ),
        ],
      },
      'Dhule': {

        'Dhule City': [
          const VillageRecord(
            villageName: 'Dhule Rural',
            lgdCode: '501138',
            gramPanchayat: 'Dhule GP',
            policeStationPostOffice: 'Dhule PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dhule North',
            lgdCode: '501139',
            gramPanchayat: 'Dhule Ward 1',
            policeStationPostOffice: 'Dhule PS / PO',
          ),
        ],
        'Dhule Block': [
          const VillageRecord(
            villageName: 'Dhule East',
            lgdCode: '501140',
            gramPanchayat: 'Dhule East GP',
            policeStationPostOffice: 'Dhule Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dhule South',
            lgdCode: '501141',
            gramPanchayat: 'Dhule South GP',
            policeStationPostOffice: 'Dhule Rural PS',
          ),
        ],
      },
      'Gadchiroli': {

        'Gadchiroli City': [
          const VillageRecord(
            villageName: 'Gadchiroli Rural',
            lgdCode: '501142',
            gramPanchayat: 'Gadchiroli GP',
            policeStationPostOffice: 'Gadchiroli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gadchiroli North',
            lgdCode: '501143',
            gramPanchayat: 'Gadchiroli Ward 1',
            policeStationPostOffice: 'Gadchiroli PS / PO',
          ),
        ],
        'Gadchiroli Block': [
          const VillageRecord(
            villageName: 'Gadchiroli East',
            lgdCode: '501144',
            gramPanchayat: 'Gadchiroli East GP',
            policeStationPostOffice: 'Gadchiroli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gadchiroli South',
            lgdCode: '501145',
            gramPanchayat: 'Gadchiroli South GP',
            policeStationPostOffice: 'Gadchiroli Rural PS',
          ),
        ],
      },
      'Gondia': {

        'Gondia City': [
          const VillageRecord(
            villageName: 'Gondia Rural',
            lgdCode: '501146',
            gramPanchayat: 'Gondia GP',
            policeStationPostOffice: 'Gondia PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gondia North',
            lgdCode: '501147',
            gramPanchayat: 'Gondia Ward 1',
            policeStationPostOffice: 'Gondia PS / PO',
          ),
        ],
        'Gondia Block': [
          const VillageRecord(
            villageName: 'Gondia East',
            lgdCode: '501148',
            gramPanchayat: 'Gondia East GP',
            policeStationPostOffice: 'Gondia Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gondia South',
            lgdCode: '501149',
            gramPanchayat: 'Gondia South GP',
            policeStationPostOffice: 'Gondia Rural PS',
          ),
        ],
      },
      'Hingoli': {

        'Hingoli City': [
          const VillageRecord(
            villageName: 'Hingoli Rural',
            lgdCode: '501150',
            gramPanchayat: 'Hingoli GP',
            policeStationPostOffice: 'Hingoli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hingoli North',
            lgdCode: '501151',
            gramPanchayat: 'Hingoli Ward 1',
            policeStationPostOffice: 'Hingoli PS / PO',
          ),
        ],
        'Hingoli Block': [
          const VillageRecord(
            villageName: 'Hingoli East',
            lgdCode: '501152',
            gramPanchayat: 'Hingoli East GP',
            policeStationPostOffice: 'Hingoli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hingoli South',
            lgdCode: '501153',
            gramPanchayat: 'Hingoli South GP',
            policeStationPostOffice: 'Hingoli Rural PS',
          ),
        ],
      },
      'Jalgaon': {

        'Jalgaon City': [
          const VillageRecord(
            villageName: 'Jalgaon Rural',
            lgdCode: '501154',
            gramPanchayat: 'Jalgaon GP',
            policeStationPostOffice: 'Jalgaon PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jalgaon North',
            lgdCode: '501155',
            gramPanchayat: 'Jalgaon Ward 1',
            policeStationPostOffice: 'Jalgaon PS / PO',
          ),
        ],
        'Jalgaon Block': [
          const VillageRecord(
            villageName: 'Jalgaon East',
            lgdCode: '501156',
            gramPanchayat: 'Jalgaon East GP',
            policeStationPostOffice: 'Jalgaon Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jalgaon South',
            lgdCode: '501157',
            gramPanchayat: 'Jalgaon South GP',
            policeStationPostOffice: 'Jalgaon Rural PS',
          ),
        ],
      },
      'Jalna': {

        'Jalna City': [
          const VillageRecord(
            villageName: 'Jalna Rural',
            lgdCode: '501158',
            gramPanchayat: 'Jalna GP',
            policeStationPostOffice: 'Jalna PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jalna North',
            lgdCode: '501159',
            gramPanchayat: 'Jalna Ward 1',
            policeStationPostOffice: 'Jalna PS / PO',
          ),
        ],
        'Jalna Block': [
          const VillageRecord(
            villageName: 'Jalna East',
            lgdCode: '501160',
            gramPanchayat: 'Jalna East GP',
            policeStationPostOffice: 'Jalna Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jalna South',
            lgdCode: '501161',
            gramPanchayat: 'Jalna South GP',
            policeStationPostOffice: 'Jalna Rural PS',
          ),
        ],
      },
      'Kolhapur': {

        'Kolhapur City': [
          const VillageRecord(
            villageName: 'Kolhapur Rural',
            lgdCode: '501162',
            gramPanchayat: 'Kolhapur GP',
            policeStationPostOffice: 'Kolhapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kolhapur North',
            lgdCode: '501163',
            gramPanchayat: 'Kolhapur Ward 1',
            policeStationPostOffice: 'Kolhapur PS / PO',
          ),
        ],
        'Kolhapur Block': [
          const VillageRecord(
            villageName: 'Kolhapur East',
            lgdCode: '501164',
            gramPanchayat: 'Kolhapur East GP',
            policeStationPostOffice: 'Kolhapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kolhapur South',
            lgdCode: '501165',
            gramPanchayat: 'Kolhapur South GP',
            policeStationPostOffice: 'Kolhapur Rural PS',
          ),
        ],
      },
      'Latur': {

        'Latur City': [
          const VillageRecord(
            villageName: 'Latur Rural',
            lgdCode: '501166',
            gramPanchayat: 'Latur GP',
            policeStationPostOffice: 'Latur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Latur North',
            lgdCode: '501167',
            gramPanchayat: 'Latur Ward 1',
            policeStationPostOffice: 'Latur PS / PO',
          ),
        ],
        'Latur Block': [
          const VillageRecord(
            villageName: 'Latur East',
            lgdCode: '501168',
            gramPanchayat: 'Latur East GP',
            policeStationPostOffice: 'Latur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Latur South',
            lgdCode: '501169',
            gramPanchayat: 'Latur South GP',
            policeStationPostOffice: 'Latur Rural PS',
          ),
        ],
      },
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
      'Nanded': {

        'Nanded City': [
          const VillageRecord(
            villageName: 'Nanded Rural',
            lgdCode: '501170',
            gramPanchayat: 'Nanded GP',
            policeStationPostOffice: 'Nanded PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nanded North',
            lgdCode: '501171',
            gramPanchayat: 'Nanded Ward 1',
            policeStationPostOffice: 'Nanded PS / PO',
          ),
        ],
        'Nanded Block': [
          const VillageRecord(
            villageName: 'Nanded East',
            lgdCode: '501172',
            gramPanchayat: 'Nanded East GP',
            policeStationPostOffice: 'Nanded Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nanded South',
            lgdCode: '501173',
            gramPanchayat: 'Nanded South GP',
            policeStationPostOffice: 'Nanded Rural PS',
          ),
        ],
      },
      'Nandurbar': {

        'Nandurbar City': [
          const VillageRecord(
            villageName: 'Nandurbar Rural',
            lgdCode: '501174',
            gramPanchayat: 'Nandurbar GP',
            policeStationPostOffice: 'Nandurbar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nandurbar North',
            lgdCode: '501175',
            gramPanchayat: 'Nandurbar Ward 1',
            policeStationPostOffice: 'Nandurbar PS / PO',
          ),
        ],
        'Nandurbar Block': [
          const VillageRecord(
            villageName: 'Nandurbar East',
            lgdCode: '501176',
            gramPanchayat: 'Nandurbar East GP',
            policeStationPostOffice: 'Nandurbar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nandurbar South',
            lgdCode: '501177',
            gramPanchayat: 'Nandurbar South GP',
            policeStationPostOffice: 'Nandurbar Rural PS',
          ),
        ],
      },
      'Nashik': {

        'Nashik City': [
          const VillageRecord(
            villageName: 'Nashik Rural',
            lgdCode: '501178',
            gramPanchayat: 'Nashik GP',
            policeStationPostOffice: 'Nashik PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nashik North',
            lgdCode: '501179',
            gramPanchayat: 'Nashik Ward 1',
            policeStationPostOffice: 'Nashik PS / PO',
          ),
        ],
        'Nashik Block': [
          const VillageRecord(
            villageName: 'Nashik East',
            lgdCode: '501180',
            gramPanchayat: 'Nashik East GP',
            policeStationPostOffice: 'Nashik Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nashik South',
            lgdCode: '501181',
            gramPanchayat: 'Nashik South GP',
            policeStationPostOffice: 'Nashik Rural PS',
          ),
        ],
      },
      'Dharashiv': {

        'Dharashiv City': [
          const VillageRecord(
            villageName: 'Dharashiv Rural',
            lgdCode: '501182',
            gramPanchayat: 'Dharashiv GP',
            policeStationPostOffice: 'Dharashiv PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dharashiv North',
            lgdCode: '501183',
            gramPanchayat: 'Dharashiv Ward 1',
            policeStationPostOffice: 'Dharashiv PS / PO',
          ),
        ],
        'Dharashiv Block': [
          const VillageRecord(
            villageName: 'Dharashiv East',
            lgdCode: '501184',
            gramPanchayat: 'Dharashiv East GP',
            policeStationPostOffice: 'Dharashiv Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dharashiv South',
            lgdCode: '501185',
            gramPanchayat: 'Dharashiv South GP',
            policeStationPostOffice: 'Dharashiv Rural PS',
          ),
        ],
      },
      'Palghar': {

        'Palghar City': [
          const VillageRecord(
            villageName: 'Palghar Rural',
            lgdCode: '501186',
            gramPanchayat: 'Palghar GP',
            policeStationPostOffice: 'Palghar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Palghar North',
            lgdCode: '501187',
            gramPanchayat: 'Palghar Ward 1',
            policeStationPostOffice: 'Palghar PS / PO',
          ),
        ],
        'Palghar Block': [
          const VillageRecord(
            villageName: 'Palghar East',
            lgdCode: '501188',
            gramPanchayat: 'Palghar East GP',
            policeStationPostOffice: 'Palghar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Palghar South',
            lgdCode: '501189',
            gramPanchayat: 'Palghar South GP',
            policeStationPostOffice: 'Palghar Rural PS',
          ),
        ],
      },
      'Parbhani': {

        'Parbhani City': [
          const VillageRecord(
            villageName: 'Parbhani Rural',
            lgdCode: '501190',
            gramPanchayat: 'Parbhani GP',
            policeStationPostOffice: 'Parbhani PS / PO',
          ),
          const VillageRecord(
            villageName: 'Parbhani North',
            lgdCode: '501191',
            gramPanchayat: 'Parbhani Ward 1',
            policeStationPostOffice: 'Parbhani PS / PO',
          ),
        ],
        'Parbhani Block': [
          const VillageRecord(
            villageName: 'Parbhani East',
            lgdCode: '501192',
            gramPanchayat: 'Parbhani East GP',
            policeStationPostOffice: 'Parbhani Rural PS',
          ),
          const VillageRecord(
            villageName: 'Parbhani South',
            lgdCode: '501193',
            gramPanchayat: 'Parbhani South GP',
            policeStationPostOffice: 'Parbhani Rural PS',
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
      'Raigad': {

        'Raigad City': [
          const VillageRecord(
            villageName: 'Raigad Rural',
            lgdCode: '501194',
            gramPanchayat: 'Raigad GP',
            policeStationPostOffice: 'Raigad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Raigad North',
            lgdCode: '501195',
            gramPanchayat: 'Raigad Ward 1',
            policeStationPostOffice: 'Raigad PS / PO',
          ),
        ],
        'Raigad Block': [
          const VillageRecord(
            villageName: 'Raigad East',
            lgdCode: '501196',
            gramPanchayat: 'Raigad East GP',
            policeStationPostOffice: 'Raigad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Raigad South',
            lgdCode: '501197',
            gramPanchayat: 'Raigad South GP',
            policeStationPostOffice: 'Raigad Rural PS',
          ),
        ],
      },
      'Ratnagiri': {

        'Ratnagiri City': [
          const VillageRecord(
            villageName: 'Ratnagiri Rural',
            lgdCode: '501198',
            gramPanchayat: 'Ratnagiri GP',
            policeStationPostOffice: 'Ratnagiri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ratnagiri North',
            lgdCode: '501199',
            gramPanchayat: 'Ratnagiri Ward 1',
            policeStationPostOffice: 'Ratnagiri PS / PO',
          ),
        ],
        'Ratnagiri Block': [
          const VillageRecord(
            villageName: 'Ratnagiri East',
            lgdCode: '501200',
            gramPanchayat: 'Ratnagiri East GP',
            policeStationPostOffice: 'Ratnagiri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ratnagiri South',
            lgdCode: '501201',
            gramPanchayat: 'Ratnagiri South GP',
            policeStationPostOffice: 'Ratnagiri Rural PS',
          ),
        ],
      },
      'Sangli': {

        'Sangli City': [
          const VillageRecord(
            villageName: 'Sangli Rural',
            lgdCode: '501202',
            gramPanchayat: 'Sangli GP',
            policeStationPostOffice: 'Sangli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sangli North',
            lgdCode: '501203',
            gramPanchayat: 'Sangli Ward 1',
            policeStationPostOffice: 'Sangli PS / PO',
          ),
        ],
        'Sangli Block': [
          const VillageRecord(
            villageName: 'Sangli East',
            lgdCode: '501204',
            gramPanchayat: 'Sangli East GP',
            policeStationPostOffice: 'Sangli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sangli South',
            lgdCode: '501205',
            gramPanchayat: 'Sangli South GP',
            policeStationPostOffice: 'Sangli Rural PS',
          ),
        ],
      },
      'Satara': {

        'Satara City': [
          const VillageRecord(
            villageName: 'Satara Rural',
            lgdCode: '501206',
            gramPanchayat: 'Satara GP',
            policeStationPostOffice: 'Satara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Satara North',
            lgdCode: '501207',
            gramPanchayat: 'Satara Ward 1',
            policeStationPostOffice: 'Satara PS / PO',
          ),
        ],
        'Satara Block': [
          const VillageRecord(
            villageName: 'Satara East',
            lgdCode: '501208',
            gramPanchayat: 'Satara East GP',
            policeStationPostOffice: 'Satara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Satara South',
            lgdCode: '501209',
            gramPanchayat: 'Satara South GP',
            policeStationPostOffice: 'Satara Rural PS',
          ),
        ],
      },
      'Sindhudurg': {

        'Sindhudurg City': [
          const VillageRecord(
            villageName: 'Sindhudurg Rural',
            lgdCode: '501210',
            gramPanchayat: 'Sindhudurg GP',
            policeStationPostOffice: 'Sindhudurg PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sindhudurg North',
            lgdCode: '501211',
            gramPanchayat: 'Sindhudurg Ward 1',
            policeStationPostOffice: 'Sindhudurg PS / PO',
          ),
        ],
        'Sindhudurg Block': [
          const VillageRecord(
            villageName: 'Sindhudurg East',
            lgdCode: '501212',
            gramPanchayat: 'Sindhudurg East GP',
            policeStationPostOffice: 'Sindhudurg Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sindhudurg South',
            lgdCode: '501213',
            gramPanchayat: 'Sindhudurg South GP',
            policeStationPostOffice: 'Sindhudurg Rural PS',
          ),
        ],
      },
      'Solapur': {

        'Solapur City': [
          const VillageRecord(
            villageName: 'Solapur Rural',
            lgdCode: '501214',
            gramPanchayat: 'Solapur GP',
            policeStationPostOffice: 'Solapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Solapur North',
            lgdCode: '501215',
            gramPanchayat: 'Solapur Ward 1',
            policeStationPostOffice: 'Solapur PS / PO',
          ),
        ],
        'Solapur Block': [
          const VillageRecord(
            villageName: 'Solapur East',
            lgdCode: '501216',
            gramPanchayat: 'Solapur East GP',
            policeStationPostOffice: 'Solapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Solapur South',
            lgdCode: '501217',
            gramPanchayat: 'Solapur South GP',
            policeStationPostOffice: 'Solapur Rural PS',
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
      'Wardha': {

        'Wardha City': [
          const VillageRecord(
            villageName: 'Wardha Rural',
            lgdCode: '501218',
            gramPanchayat: 'Wardha GP',
            policeStationPostOffice: 'Wardha PS / PO',
          ),
          const VillageRecord(
            villageName: 'Wardha North',
            lgdCode: '501219',
            gramPanchayat: 'Wardha Ward 1',
            policeStationPostOffice: 'Wardha PS / PO',
          ),
        ],
        'Wardha Block': [
          const VillageRecord(
            villageName: 'Wardha East',
            lgdCode: '501220',
            gramPanchayat: 'Wardha East GP',
            policeStationPostOffice: 'Wardha Rural PS',
          ),
          const VillageRecord(
            villageName: 'Wardha South',
            lgdCode: '501221',
            gramPanchayat: 'Wardha South GP',
            policeStationPostOffice: 'Wardha Rural PS',
          ),
        ],
      },
      'Washim': {

        'Washim City': [
          const VillageRecord(
            villageName: 'Washim Rural',
            lgdCode: '501222',
            gramPanchayat: 'Washim GP',
            policeStationPostOffice: 'Washim PS / PO',
          ),
          const VillageRecord(
            villageName: 'Washim North',
            lgdCode: '501223',
            gramPanchayat: 'Washim Ward 1',
            policeStationPostOffice: 'Washim PS / PO',
          ),
        ],
        'Washim Block': [
          const VillageRecord(
            villageName: 'Washim East',
            lgdCode: '501224',
            gramPanchayat: 'Washim East GP',
            policeStationPostOffice: 'Washim Rural PS',
          ),
          const VillageRecord(
            villageName: 'Washim South',
            lgdCode: '501225',
            gramPanchayat: 'Washim South GP',
            policeStationPostOffice: 'Washim Rural PS',
          ),
        ],
      },
      'Yavatmal': {

        'Yavatmal City': [
          const VillageRecord(
            villageName: 'Yavatmal Rural',
            lgdCode: '501226',
            gramPanchayat: 'Yavatmal GP',
            policeStationPostOffice: 'Yavatmal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Yavatmal North',
            lgdCode: '501227',
            gramPanchayat: 'Yavatmal Ward 1',
            policeStationPostOffice: 'Yavatmal PS / PO',
          ),
        ],
        'Yavatmal Block': [
          const VillageRecord(
            villageName: 'Yavatmal East',
            lgdCode: '501228',
            gramPanchayat: 'Yavatmal East GP',
            policeStationPostOffice: 'Yavatmal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Yavatmal South',
            lgdCode: '501229',
            gramPanchayat: 'Yavatmal South GP',
            policeStationPostOffice: 'Yavatmal Rural PS',
          ),
        ],
      },
    },
    'Manipur': {
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
      'Chandel': {

        'Chandel City': [
          const VillageRecord(
            villageName: 'Chandel Rural',
            lgdCode: '501230',
            gramPanchayat: 'Chandel GP',
            policeStationPostOffice: 'Chandel PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chandel North',
            lgdCode: '501231',
            gramPanchayat: 'Chandel Ward 1',
            policeStationPostOffice: 'Chandel PS / PO',
          ),
        ],
        'Chandel Block': [
          const VillageRecord(
            villageName: 'Chandel East',
            lgdCode: '501232',
            gramPanchayat: 'Chandel East GP',
            policeStationPostOffice: 'Chandel Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chandel South',
            lgdCode: '501233',
            gramPanchayat: 'Chandel South GP',
            policeStationPostOffice: 'Chandel Rural PS',
          ),
        ],
      },
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
      'Jiribam': {

        'Jiribam City': [
          const VillageRecord(
            villageName: 'Jiribam Rural',
            lgdCode: '501234',
            gramPanchayat: 'Jiribam GP',
            policeStationPostOffice: 'Jiribam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jiribam North',
            lgdCode: '501235',
            gramPanchayat: 'Jiribam Ward 1',
            policeStationPostOffice: 'Jiribam PS / PO',
          ),
        ],
        'Jiribam Block': [
          const VillageRecord(
            villageName: 'Jiribam East',
            lgdCode: '501236',
            gramPanchayat: 'Jiribam East GP',
            policeStationPostOffice: 'Jiribam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jiribam South',
            lgdCode: '501237',
            gramPanchayat: 'Jiribam South GP',
            policeStationPostOffice: 'Jiribam Rural PS',
          ),
        ],
      },
      'Kakching': {

        'Kakching City': [
          const VillageRecord(
            villageName: 'Kakching Rural',
            lgdCode: '501238',
            gramPanchayat: 'Kakching GP',
            policeStationPostOffice: 'Kakching PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kakching North',
            lgdCode: '501239',
            gramPanchayat: 'Kakching Ward 1',
            policeStationPostOffice: 'Kakching PS / PO',
          ),
        ],
        'Kakching Block': [
          const VillageRecord(
            villageName: 'Kakching East',
            lgdCode: '501240',
            gramPanchayat: 'Kakching East GP',
            policeStationPostOffice: 'Kakching Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kakching South',
            lgdCode: '501241',
            gramPanchayat: 'Kakching South GP',
            policeStationPostOffice: 'Kakching Rural PS',
          ),
        ],
      },
      'Kamjong': {

        'Kamjong City': [
          const VillageRecord(
            villageName: 'Kamjong Rural',
            lgdCode: '501242',
            gramPanchayat: 'Kamjong GP',
            policeStationPostOffice: 'Kamjong PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kamjong North',
            lgdCode: '501243',
            gramPanchayat: 'Kamjong Ward 1',
            policeStationPostOffice: 'Kamjong PS / PO',
          ),
        ],
        'Kamjong Block': [
          const VillageRecord(
            villageName: 'Kamjong East',
            lgdCode: '501244',
            gramPanchayat: 'Kamjong East GP',
            policeStationPostOffice: 'Kamjong Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kamjong South',
            lgdCode: '501245',
            gramPanchayat: 'Kamjong South GP',
            policeStationPostOffice: 'Kamjong Rural PS',
          ),
        ],
      },
      'Kangpokpi': {

        'Kangpokpi City': [
          const VillageRecord(
            villageName: 'Kangpokpi Rural',
            lgdCode: '501246',
            gramPanchayat: 'Kangpokpi GP',
            policeStationPostOffice: 'Kangpokpi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kangpokpi North',
            lgdCode: '501247',
            gramPanchayat: 'Kangpokpi Ward 1',
            policeStationPostOffice: 'Kangpokpi PS / PO',
          ),
        ],
        'Kangpokpi Block': [
          const VillageRecord(
            villageName: 'Kangpokpi East',
            lgdCode: '501248',
            gramPanchayat: 'Kangpokpi East GP',
            policeStationPostOffice: 'Kangpokpi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kangpokpi South',
            lgdCode: '501249',
            gramPanchayat: 'Kangpokpi South GP',
            policeStationPostOffice: 'Kangpokpi Rural PS',
          ),
        ],
      },
      'Noney': {

        'Noney City': [
          const VillageRecord(
            villageName: 'Noney Rural',
            lgdCode: '501250',
            gramPanchayat: 'Noney GP',
            policeStationPostOffice: 'Noney PS / PO',
          ),
          const VillageRecord(
            villageName: 'Noney North',
            lgdCode: '501251',
            gramPanchayat: 'Noney Ward 1',
            policeStationPostOffice: 'Noney PS / PO',
          ),
        ],
        'Noney Block': [
          const VillageRecord(
            villageName: 'Noney East',
            lgdCode: '501252',
            gramPanchayat: 'Noney East GP',
            policeStationPostOffice: 'Noney Rural PS',
          ),
          const VillageRecord(
            villageName: 'Noney South',
            lgdCode: '501253',
            gramPanchayat: 'Noney South GP',
            policeStationPostOffice: 'Noney Rural PS',
          ),
        ],
      },
      'Pherzawl': {

        'Pherzawl City': [
          const VillageRecord(
            villageName: 'Pherzawl Rural',
            lgdCode: '501254',
            gramPanchayat: 'Pherzawl GP',
            policeStationPostOffice: 'Pherzawl PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pherzawl North',
            lgdCode: '501255',
            gramPanchayat: 'Pherzawl Ward 1',
            policeStationPostOffice: 'Pherzawl PS / PO',
          ),
        ],
        'Pherzawl Block': [
          const VillageRecord(
            villageName: 'Pherzawl East',
            lgdCode: '501256',
            gramPanchayat: 'Pherzawl East GP',
            policeStationPostOffice: 'Pherzawl Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pherzawl South',
            lgdCode: '501257',
            gramPanchayat: 'Pherzawl South GP',
            policeStationPostOffice: 'Pherzawl Rural PS',
          ),
        ],
      },
      'Senapati': {

        'Senapati City': [
          const VillageRecord(
            villageName: 'Senapati Rural',
            lgdCode: '501258',
            gramPanchayat: 'Senapati GP',
            policeStationPostOffice: 'Senapati PS / PO',
          ),
          const VillageRecord(
            villageName: 'Senapati North',
            lgdCode: '501259',
            gramPanchayat: 'Senapati Ward 1',
            policeStationPostOffice: 'Senapati PS / PO',
          ),
        ],
        'Senapati Block': [
          const VillageRecord(
            villageName: 'Senapati East',
            lgdCode: '501260',
            gramPanchayat: 'Senapati East GP',
            policeStationPostOffice: 'Senapati Rural PS',
          ),
          const VillageRecord(
            villageName: 'Senapati South',
            lgdCode: '501261',
            gramPanchayat: 'Senapati South GP',
            policeStationPostOffice: 'Senapati Rural PS',
          ),
        ],
      },
      'Tamenglong': {

        'Tamenglong City': [
          const VillageRecord(
            villageName: 'Tamenglong Rural',
            lgdCode: '501262',
            gramPanchayat: 'Tamenglong GP',
            policeStationPostOffice: 'Tamenglong PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tamenglong North',
            lgdCode: '501263',
            gramPanchayat: 'Tamenglong Ward 1',
            policeStationPostOffice: 'Tamenglong PS / PO',
          ),
        ],
        'Tamenglong Block': [
          const VillageRecord(
            villageName: 'Tamenglong East',
            lgdCode: '501264',
            gramPanchayat: 'Tamenglong East GP',
            policeStationPostOffice: 'Tamenglong Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tamenglong South',
            lgdCode: '501265',
            gramPanchayat: 'Tamenglong South GP',
            policeStationPostOffice: 'Tamenglong Rural PS',
          ),
        ],
      },
      'Tengnoupal': {

        'Tengnoupal City': [
          const VillageRecord(
            villageName: 'Tengnoupal Rural',
            lgdCode: '501266',
            gramPanchayat: 'Tengnoupal GP',
            policeStationPostOffice: 'Tengnoupal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tengnoupal North',
            lgdCode: '501267',
            gramPanchayat: 'Tengnoupal Ward 1',
            policeStationPostOffice: 'Tengnoupal PS / PO',
          ),
        ],
        'Tengnoupal Block': [
          const VillageRecord(
            villageName: 'Tengnoupal East',
            lgdCode: '501268',
            gramPanchayat: 'Tengnoupal East GP',
            policeStationPostOffice: 'Tengnoupal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tengnoupal South',
            lgdCode: '501269',
            gramPanchayat: 'Tengnoupal South GP',
            policeStationPostOffice: 'Tengnoupal Rural PS',
          ),
        ],
      },
      'Thoubal': {

        'Thoubal City': [
          const VillageRecord(
            villageName: 'Thoubal Rural',
            lgdCode: '501270',
            gramPanchayat: 'Thoubal GP',
            policeStationPostOffice: 'Thoubal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Thoubal North',
            lgdCode: '501271',
            gramPanchayat: 'Thoubal Ward 1',
            policeStationPostOffice: 'Thoubal PS / PO',
          ),
        ],
        'Thoubal Block': [
          const VillageRecord(
            villageName: 'Thoubal East',
            lgdCode: '501272',
            gramPanchayat: 'Thoubal East GP',
            policeStationPostOffice: 'Thoubal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Thoubal South',
            lgdCode: '501273',
            gramPanchayat: 'Thoubal South GP',
            policeStationPostOffice: 'Thoubal Rural PS',
          ),
        ],
      },
      'Ukhrul': {

        'Ukhrul City': [
          const VillageRecord(
            villageName: 'Ukhrul Rural',
            lgdCode: '501274',
            gramPanchayat: 'Ukhrul GP',
            policeStationPostOffice: 'Ukhrul PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ukhrul North',
            lgdCode: '501275',
            gramPanchayat: 'Ukhrul Ward 1',
            policeStationPostOffice: 'Ukhrul PS / PO',
          ),
        ],
        'Ukhrul Block': [
          const VillageRecord(
            villageName: 'Ukhrul East',
            lgdCode: '501276',
            gramPanchayat: 'Ukhrul East GP',
            policeStationPostOffice: 'Ukhrul Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ukhrul South',
            lgdCode: '501277',
            gramPanchayat: 'Ukhrul South GP',
            policeStationPostOffice: 'Ukhrul Rural PS',
          ),
        ],
      },
    },
    'Meghalaya': {
      'East Garo Hills': {

        'East Garo Hills City': [
          const VillageRecord(
            villageName: 'East Garo Hills Rural',
            lgdCode: '501278',
            gramPanchayat: 'East Garo Hills GP',
            policeStationPostOffice: 'East Garo Hills PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Garo Hills North',
            lgdCode: '501279',
            gramPanchayat: 'East Garo Hills Ward 1',
            policeStationPostOffice: 'East Garo Hills PS / PO',
          ),
        ],
        'East Garo Hills Block': [
          const VillageRecord(
            villageName: 'East Garo Hills East',
            lgdCode: '501280',
            gramPanchayat: 'East Garo Hills East GP',
            policeStationPostOffice: 'East Garo Hills Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Garo Hills South',
            lgdCode: '501281',
            gramPanchayat: 'East Garo Hills South GP',
            policeStationPostOffice: 'East Garo Hills Rural PS',
          ),
        ],
      },
      'East Jaintia Hills': {

        'East Jaintia Hills City': [
          const VillageRecord(
            villageName: 'East Jaintia Hills Rural',
            lgdCode: '501282',
            gramPanchayat: 'East Jaintia Hills GP',
            policeStationPostOffice: 'East Jaintia Hills PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Jaintia Hills North',
            lgdCode: '501283',
            gramPanchayat: 'East Jaintia Hills Ward 1',
            policeStationPostOffice: 'East Jaintia Hills PS / PO',
          ),
        ],
        'East Jaintia Hills Block': [
          const VillageRecord(
            villageName: 'East Jaintia Hills East',
            lgdCode: '501284',
            gramPanchayat: 'East Jaintia Hills East GP',
            policeStationPostOffice: 'East Jaintia Hills Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Jaintia Hills South',
            lgdCode: '501285',
            gramPanchayat: 'East Jaintia Hills South GP',
            policeStationPostOffice: 'East Jaintia Hills Rural PS',
          ),
        ],
      },
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
      'North Garo Hills': {

        'North Garo Hills City': [
          const VillageRecord(
            villageName: 'North Garo Hills Rural',
            lgdCode: '501286',
            gramPanchayat: 'North Garo Hills GP',
            policeStationPostOffice: 'North Garo Hills PS / PO',
          ),
          const VillageRecord(
            villageName: 'North Garo Hills North',
            lgdCode: '501287',
            gramPanchayat: 'North Garo Hills Ward 1',
            policeStationPostOffice: 'North Garo Hills PS / PO',
          ),
        ],
        'North Garo Hills Block': [
          const VillageRecord(
            villageName: 'North Garo Hills East',
            lgdCode: '501288',
            gramPanchayat: 'North Garo Hills East GP',
            policeStationPostOffice: 'North Garo Hills Rural PS',
          ),
          const VillageRecord(
            villageName: 'North Garo Hills South',
            lgdCode: '501289',
            gramPanchayat: 'North Garo Hills South GP',
            policeStationPostOffice: 'North Garo Hills Rural PS',
          ),
        ],
      },
      'Ri Bhoi': {

        'Ri Bhoi City': [
          const VillageRecord(
            villageName: 'Ri Bhoi Rural',
            lgdCode: '501290',
            gramPanchayat: 'Ri Bhoi GP',
            policeStationPostOffice: 'Ri Bhoi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ri Bhoi North',
            lgdCode: '501291',
            gramPanchayat: 'Ri Bhoi Ward 1',
            policeStationPostOffice: 'Ri Bhoi PS / PO',
          ),
        ],
        'Ri Bhoi Block': [
          const VillageRecord(
            villageName: 'Ri Bhoi East',
            lgdCode: '501292',
            gramPanchayat: 'Ri Bhoi East GP',
            policeStationPostOffice: 'Ri Bhoi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ri Bhoi South',
            lgdCode: '501293',
            gramPanchayat: 'Ri Bhoi South GP',
            policeStationPostOffice: 'Ri Bhoi Rural PS',
          ),
        ],
      },
      'South Garo Hills': {

        'South Garo Hills City': [
          const VillageRecord(
            villageName: 'South Garo Hills Rural',
            lgdCode: '501294',
            gramPanchayat: 'South Garo Hills GP',
            policeStationPostOffice: 'South Garo Hills PS / PO',
          ),
          const VillageRecord(
            villageName: 'South Garo Hills North',
            lgdCode: '501295',
            gramPanchayat: 'South Garo Hills Ward 1',
            policeStationPostOffice: 'South Garo Hills PS / PO',
          ),
        ],
        'South Garo Hills Block': [
          const VillageRecord(
            villageName: 'South Garo Hills East',
            lgdCode: '501296',
            gramPanchayat: 'South Garo Hills East GP',
            policeStationPostOffice: 'South Garo Hills Rural PS',
          ),
          const VillageRecord(
            villageName: 'South Garo Hills South',
            lgdCode: '501297',
            gramPanchayat: 'South Garo Hills South GP',
            policeStationPostOffice: 'South Garo Hills Rural PS',
          ),
        ],
      },
      'South West Garo Hills': {


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
      'South West Khasi Hills': {

        'South West Khasi Hills City': [
          const VillageRecord(
            villageName: 'South West Khasi Hills Rural',
            lgdCode: '501298',
            gramPanchayat: 'South West Khasi Hills GP',
            policeStationPostOffice: 'South West Khasi Hills PS / PO',
          ),
          const VillageRecord(
            villageName: 'South West Khasi Hills North',
            lgdCode: '501299',
            gramPanchayat: 'South West Khasi Hills Ward 1',
            policeStationPostOffice: 'South West Khasi Hills PS / PO',
          ),
        ],
        'South West Khasi Hills Block': [
          const VillageRecord(
            villageName: 'South West Khasi Hills East',
            lgdCode: '501300',
            gramPanchayat: 'South West Khasi Hills East GP',
            policeStationPostOffice: 'South West Khasi Hills Rural PS',
          ),
          const VillageRecord(
            villageName: 'South West Khasi Hills South',
            lgdCode: '501301',
            gramPanchayat: 'South West Khasi Hills South GP',
            policeStationPostOffice: 'South West Khasi Hills Rural PS',
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
      'West Jaintia Hills': {

        'West Jaintia Hills City': [
          const VillageRecord(
            villageName: 'West Jaintia Hills Rural',
            lgdCode: '501302',
            gramPanchayat: 'West Jaintia Hills GP',
            policeStationPostOffice: 'West Jaintia Hills PS / PO',
          ),
          const VillageRecord(
            villageName: 'West Jaintia Hills North',
            lgdCode: '501303',
            gramPanchayat: 'West Jaintia Hills Ward 1',
            policeStationPostOffice: 'West Jaintia Hills PS / PO',
          ),
        ],
        'West Jaintia Hills Block': [
          const VillageRecord(
            villageName: 'West Jaintia Hills East',
            lgdCode: '501304',
            gramPanchayat: 'West Jaintia Hills East GP',
            policeStationPostOffice: 'West Jaintia Hills Rural PS',
          ),
          const VillageRecord(
            villageName: 'West Jaintia Hills South',
            lgdCode: '501305',
            gramPanchayat: 'West Jaintia Hills South GP',
            policeStationPostOffice: 'West Jaintia Hills Rural PS',
          ),
        ],
      },
      'West Khasi Hills': {

        'South West Khasi Hills City': [
          const VillageRecord(
            villageName: 'South West Khasi Hills Rural',
            lgdCode: '501298',
            gramPanchayat: 'South West Khasi Hills GP',
            policeStationPostOffice: 'South West Khasi Hills PS / PO',
          ),
          const VillageRecord(
            villageName: 'South West Khasi Hills North',
            lgdCode: '501299',
            gramPanchayat: 'South West Khasi Hills Ward 1',
            policeStationPostOffice: 'South West Khasi Hills PS / PO',
          ),
        ],
        'South West Khasi Hills Block': [
          const VillageRecord(
            villageName: 'South West Khasi Hills East',
            lgdCode: '501300',
            gramPanchayat: 'South West Khasi Hills East GP',
            policeStationPostOffice: 'South West Khasi Hills Rural PS',
          ),
          const VillageRecord(
            villageName: 'South West Khasi Hills South',
            lgdCode: '501301',
            gramPanchayat: 'South West Khasi Hills South GP',
            policeStationPostOffice: 'South West Khasi Hills Rural PS',
          ),
        ],
      },
      'Eastern West Khasi Hills': {

        'West Khasi Hills City': [
          const VillageRecord(
            villageName: 'West Khasi Hills Rural',
            lgdCode: '501306',
            gramPanchayat: 'West Khasi Hills GP',
            policeStationPostOffice: 'West Khasi Hills PS / PO',
          ),
          const VillageRecord(
            villageName: 'West Khasi Hills North',
            lgdCode: '501307',
            gramPanchayat: 'West Khasi Hills Ward 1',
            policeStationPostOffice: 'West Khasi Hills PS / PO',
          ),
        ],
        'West Khasi Hills Block': [
          const VillageRecord(
            villageName: 'West Khasi Hills East',
            lgdCode: '501308',
            gramPanchayat: 'West Khasi Hills East GP',
            policeStationPostOffice: 'West Khasi Hills Rural PS',
          ),
          const VillageRecord(
            villageName: 'West Khasi Hills South',
            lgdCode: '501309',
            gramPanchayat: 'West Khasi Hills South GP',
            policeStationPostOffice: 'West Khasi Hills Rural PS',
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
      'Champhai': {

        'Champhai City': [
          const VillageRecord(
            villageName: 'Champhai Rural',
            lgdCode: '501314',
            gramPanchayat: 'Champhai GP',
            policeStationPostOffice: 'Champhai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Champhai North',
            lgdCode: '501315',
            gramPanchayat: 'Champhai Ward 1',
            policeStationPostOffice: 'Champhai PS / PO',
          ),
        ],
        'Champhai Block': [
          const VillageRecord(
            villageName: 'Champhai East',
            lgdCode: '501316',
            gramPanchayat: 'Champhai East GP',
            policeStationPostOffice: 'Champhai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Champhai South',
            lgdCode: '501317',
            gramPanchayat: 'Champhai South GP',
            policeStationPostOffice: 'Champhai Rural PS',
          ),
        ],
      },
      'Hnahthial': {

        'Hnahthial City': [
          const VillageRecord(
            villageName: 'Hnahthial Rural',
            lgdCode: '501318',
            gramPanchayat: 'Hnahthial GP',
            policeStationPostOffice: 'Hnahthial PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hnahthial North',
            lgdCode: '501319',
            gramPanchayat: 'Hnahthial Ward 1',
            policeStationPostOffice: 'Hnahthial PS / PO',
          ),
        ],
        'Hnahthial Block': [
          const VillageRecord(
            villageName: 'Hnahthial East',
            lgdCode: '501320',
            gramPanchayat: 'Hnahthial East GP',
            policeStationPostOffice: 'Hnahthial Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hnahthial South',
            lgdCode: '501321',
            gramPanchayat: 'Hnahthial South GP',
            policeStationPostOffice: 'Hnahthial Rural PS',
          ),
        ],
      },
      'Khawzawl': {

        'Khawzawl City': [
          const VillageRecord(
            villageName: 'Khawzawl Rural',
            lgdCode: '501322',
            gramPanchayat: 'Khawzawl GP',
            policeStationPostOffice: 'Khawzawl PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khawzawl North',
            lgdCode: '501323',
            gramPanchayat: 'Khawzawl Ward 1',
            policeStationPostOffice: 'Khawzawl PS / PO',
          ),
        ],
        'Khawzawl Block': [
          const VillageRecord(
            villageName: 'Khawzawl East',
            lgdCode: '501324',
            gramPanchayat: 'Khawzawl East GP',
            policeStationPostOffice: 'Khawzawl Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khawzawl South',
            lgdCode: '501325',
            gramPanchayat: 'Khawzawl South GP',
            policeStationPostOffice: 'Khawzawl Rural PS',
          ),
        ],
      },
      'Kolasib': {

        'Kolasib City': [
          const VillageRecord(
            villageName: 'Kolasib Rural',
            lgdCode: '501326',
            gramPanchayat: 'Kolasib GP',
            policeStationPostOffice: 'Kolasib PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kolasib North',
            lgdCode: '501327',
            gramPanchayat: 'Kolasib Ward 1',
            policeStationPostOffice: 'Kolasib PS / PO',
          ),
        ],
        'Kolasib Block': [
          const VillageRecord(
            villageName: 'Kolasib East',
            lgdCode: '501328',
            gramPanchayat: 'Kolasib East GP',
            policeStationPostOffice: 'Kolasib Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kolasib South',
            lgdCode: '501329',
            gramPanchayat: 'Kolasib South GP',
            policeStationPostOffice: 'Kolasib Rural PS',
          ),
        ],
      },
      'Lawngtlai': {

        'Lawngtlai City': [
          const VillageRecord(
            villageName: 'Lawngtlai Rural',
            lgdCode: '501330',
            gramPanchayat: 'Lawngtlai GP',
            policeStationPostOffice: 'Lawngtlai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lawngtlai North',
            lgdCode: '501331',
            gramPanchayat: 'Lawngtlai Ward 1',
            policeStationPostOffice: 'Lawngtlai PS / PO',
          ),
        ],
        'Lawngtlai Block': [
          const VillageRecord(
            villageName: 'Lawngtlai East',
            lgdCode: '501332',
            gramPanchayat: 'Lawngtlai East GP',
            policeStationPostOffice: 'Lawngtlai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lawngtlai South',
            lgdCode: '501333',
            gramPanchayat: 'Lawngtlai South GP',
            policeStationPostOffice: 'Lawngtlai Rural PS',
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
      'Mamit': {

        'Mamit City': [
          const VillageRecord(
            villageName: 'Mamit Rural',
            lgdCode: '501334',
            gramPanchayat: 'Mamit GP',
            policeStationPostOffice: 'Mamit PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mamit North',
            lgdCode: '501335',
            gramPanchayat: 'Mamit Ward 1',
            policeStationPostOffice: 'Mamit PS / PO',
          ),
        ],
        'Mamit Block': [
          const VillageRecord(
            villageName: 'Mamit East',
            lgdCode: '501336',
            gramPanchayat: 'Mamit East GP',
            policeStationPostOffice: 'Mamit Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mamit South',
            lgdCode: '501337',
            gramPanchayat: 'Mamit South GP',
            policeStationPostOffice: 'Mamit Rural PS',
          ),
        ],
      },
      'Saiha': {

        'Saiha City': [
          const VillageRecord(
            villageName: 'Saiha Rural',
            lgdCode: '501338',
            gramPanchayat: 'Saiha GP',
            policeStationPostOffice: 'Saiha PS / PO',
          ),
          const VillageRecord(
            villageName: 'Saiha North',
            lgdCode: '501339',
            gramPanchayat: 'Saiha Ward 1',
            policeStationPostOffice: 'Saiha PS / PO',
          ),
        ],
        'Saiha Block': [
          const VillageRecord(
            villageName: 'Saiha East',
            lgdCode: '501340',
            gramPanchayat: 'Saiha East GP',
            policeStationPostOffice: 'Saiha Rural PS',
          ),
          const VillageRecord(
            villageName: 'Saiha South',
            lgdCode: '501341',
            gramPanchayat: 'Saiha South GP',
            policeStationPostOffice: 'Saiha Rural PS',
          ),
        ],
      },
      'Saitual': {

        'Saitual City': [
          const VillageRecord(
            villageName: 'Saitual Rural',
            lgdCode: '501342',
            gramPanchayat: 'Saitual GP',
            policeStationPostOffice: 'Saitual PS / PO',
          ),
          const VillageRecord(
            villageName: 'Saitual North',
            lgdCode: '501343',
            gramPanchayat: 'Saitual Ward 1',
            policeStationPostOffice: 'Saitual PS / PO',
          ),
        ],
        'Saitual Block': [
          const VillageRecord(
            villageName: 'Saitual East',
            lgdCode: '501344',
            gramPanchayat: 'Saitual East GP',
            policeStationPostOffice: 'Saitual Rural PS',
          ),
          const VillageRecord(
            villageName: 'Saitual South',
            lgdCode: '501345',
            gramPanchayat: 'Saitual South GP',
            policeStationPostOffice: 'Saitual Rural PS',
          ),
        ],
      },
      'Serchhip': {

        'Serchhip City': [
          const VillageRecord(
            villageName: 'Serchhip Rural',
            lgdCode: '501346',
            gramPanchayat: 'Serchhip GP',
            policeStationPostOffice: 'Serchhip PS / PO',
          ),
          const VillageRecord(
            villageName: 'Serchhip North',
            lgdCode: '501347',
            gramPanchayat: 'Serchhip Ward 1',
            policeStationPostOffice: 'Serchhip PS / PO',
          ),
        ],
        'Serchhip Block': [
          const VillageRecord(
            villageName: 'Serchhip East',
            lgdCode: '501348',
            gramPanchayat: 'Serchhip East GP',
            policeStationPostOffice: 'Serchhip Rural PS',
          ),
          const VillageRecord(
            villageName: 'Serchhip South',
            lgdCode: '501349',
            gramPanchayat: 'Serchhip South GP',
            policeStationPostOffice: 'Serchhip Rural PS',
          ),
        ],
      },
    },
    'Nagaland': {
      'Chumoukedima': {

        'Chumoukedima City': [
          const VillageRecord(
            villageName: 'Chumoukedima Rural',
            lgdCode: '501350',
            gramPanchayat: 'Chumoukedima GP',
            policeStationPostOffice: 'Chumoukedima PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chumoukedima North',
            lgdCode: '501351',
            gramPanchayat: 'Chumoukedima Ward 1',
            policeStationPostOffice: 'Chumoukedima PS / PO',
          ),
        ],
        'Chumoukedima Block': [
          const VillageRecord(
            villageName: 'Chumoukedima East',
            lgdCode: '501352',
            gramPanchayat: 'Chumoukedima East GP',
            policeStationPostOffice: 'Chumoukedima Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chumoukedima South',
            lgdCode: '501353',
            gramPanchayat: 'Chumoukedima South GP',
            policeStationPostOffice: 'Chumoukedima Rural PS',
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
      'Kiphire': {

        'Kiphire City': [
          const VillageRecord(
            villageName: 'Kiphire Rural',
            lgdCode: '501354',
            gramPanchayat: 'Kiphire GP',
            policeStationPostOffice: 'Kiphire PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kiphire North',
            lgdCode: '501355',
            gramPanchayat: 'Kiphire Ward 1',
            policeStationPostOffice: 'Kiphire PS / PO',
          ),
        ],
        'Kiphire Block': [
          const VillageRecord(
            villageName: 'Kiphire East',
            lgdCode: '501356',
            gramPanchayat: 'Kiphire East GP',
            policeStationPostOffice: 'Kiphire Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kiphire South',
            lgdCode: '501357',
            gramPanchayat: 'Kiphire South GP',
            policeStationPostOffice: 'Kiphire Rural PS',
          ),
        ],
      },
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
      'Longleng': {

        'Longleng City': [
          const VillageRecord(
            villageName: 'Longleng Rural',
            lgdCode: '501358',
            gramPanchayat: 'Longleng GP',
            policeStationPostOffice: 'Longleng PS / PO',
          ),
          const VillageRecord(
            villageName: 'Longleng North',
            lgdCode: '501359',
            gramPanchayat: 'Longleng Ward 1',
            policeStationPostOffice: 'Longleng PS / PO',
          ),
        ],
        'Longleng Block': [
          const VillageRecord(
            villageName: 'Longleng East',
            lgdCode: '501360',
            gramPanchayat: 'Longleng East GP',
            policeStationPostOffice: 'Longleng Rural PS',
          ),
          const VillageRecord(
            villageName: 'Longleng South',
            lgdCode: '501361',
            gramPanchayat: 'Longleng South GP',
            policeStationPostOffice: 'Longleng Rural PS',
          ),
        ],
      },
      'Mokokchung': {

        'Mokokchung City': [
          const VillageRecord(
            villageName: 'Mokokchung Rural',
            lgdCode: '501362',
            gramPanchayat: 'Mokokchung GP',
            policeStationPostOffice: 'Mokokchung PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mokokchung North',
            lgdCode: '501363',
            gramPanchayat: 'Mokokchung Ward 1',
            policeStationPostOffice: 'Mokokchung PS / PO',
          ),
        ],
        'Mokokchung Block': [
          const VillageRecord(
            villageName: 'Mokokchung East',
            lgdCode: '501364',
            gramPanchayat: 'Mokokchung East GP',
            policeStationPostOffice: 'Mokokchung Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mokokchung South',
            lgdCode: '501365',
            gramPanchayat: 'Mokokchung South GP',
            policeStationPostOffice: 'Mokokchung Rural PS',
          ),
        ],
      },
      'Mon': {

        'Mon City': [
          const VillageRecord(
            villageName: 'Mon Rural',
            lgdCode: '501366',
            gramPanchayat: 'Mon GP',
            policeStationPostOffice: 'Mon PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mon North',
            lgdCode: '501367',
            gramPanchayat: 'Mon Ward 1',
            policeStationPostOffice: 'Mon PS / PO',
          ),
        ],
        'Mon Block': [
          const VillageRecord(
            villageName: 'Mon East',
            lgdCode: '501368',
            gramPanchayat: 'Mon East GP',
            policeStationPostOffice: 'Mon Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mon South',
            lgdCode: '501369',
            gramPanchayat: 'Mon South GP',
            policeStationPostOffice: 'Mon Rural PS',
          ),
        ],
      },
      'Niuland': {

        'Niuland City': [
          const VillageRecord(
            villageName: 'Niuland Rural',
            lgdCode: '501370',
            gramPanchayat: 'Niuland GP',
            policeStationPostOffice: 'Niuland PS / PO',
          ),
          const VillageRecord(
            villageName: 'Niuland North',
            lgdCode: '501371',
            gramPanchayat: 'Niuland Ward 1',
            policeStationPostOffice: 'Niuland PS / PO',
          ),
        ],
        'Niuland Block': [
          const VillageRecord(
            villageName: 'Niuland East',
            lgdCode: '501372',
            gramPanchayat: 'Niuland East GP',
            policeStationPostOffice: 'Niuland Rural PS',
          ),
          const VillageRecord(
            villageName: 'Niuland South',
            lgdCode: '501373',
            gramPanchayat: 'Niuland South GP',
            policeStationPostOffice: 'Niuland Rural PS',
          ),
        ],
      },
      'Noklak': {

        'Noklak City': [
          const VillageRecord(
            villageName: 'Noklak Rural',
            lgdCode: '501374',
            gramPanchayat: 'Noklak GP',
            policeStationPostOffice: 'Noklak PS / PO',
          ),
          const VillageRecord(
            villageName: 'Noklak North',
            lgdCode: '501375',
            gramPanchayat: 'Noklak Ward 1',
            policeStationPostOffice: 'Noklak PS / PO',
          ),
        ],
        'Noklak Block': [
          const VillageRecord(
            villageName: 'Noklak East',
            lgdCode: '501376',
            gramPanchayat: 'Noklak East GP',
            policeStationPostOffice: 'Noklak Rural PS',
          ),
          const VillageRecord(
            villageName: 'Noklak South',
            lgdCode: '501377',
            gramPanchayat: 'Noklak South GP',
            policeStationPostOffice: 'Noklak Rural PS',
          ),
        ],
      },
      'Peren': {

        'Peren City': [
          const VillageRecord(
            villageName: 'Peren Rural',
            lgdCode: '501378',
            gramPanchayat: 'Peren GP',
            policeStationPostOffice: 'Peren PS / PO',
          ),
          const VillageRecord(
            villageName: 'Peren North',
            lgdCode: '501379',
            gramPanchayat: 'Peren Ward 1',
            policeStationPostOffice: 'Peren PS / PO',
          ),
        ],
        'Peren Block': [
          const VillageRecord(
            villageName: 'Peren East',
            lgdCode: '501380',
            gramPanchayat: 'Peren East GP',
            policeStationPostOffice: 'Peren Rural PS',
          ),
          const VillageRecord(
            villageName: 'Peren South',
            lgdCode: '501381',
            gramPanchayat: 'Peren South GP',
            policeStationPostOffice: 'Peren Rural PS',
          ),
        ],
      },
      'Phek': {

        'Phek City': [
          const VillageRecord(
            villageName: 'Phek Rural',
            lgdCode: '501382',
            gramPanchayat: 'Phek GP',
            policeStationPostOffice: 'Phek PS / PO',
          ),
          const VillageRecord(
            villageName: 'Phek North',
            lgdCode: '501383',
            gramPanchayat: 'Phek Ward 1',
            policeStationPostOffice: 'Phek PS / PO',
          ),
        ],
        'Phek Block': [
          const VillageRecord(
            villageName: 'Phek East',
            lgdCode: '501384',
            gramPanchayat: 'Phek East GP',
            policeStationPostOffice: 'Phek Rural PS',
          ),
          const VillageRecord(
            villageName: 'Phek South',
            lgdCode: '501385',
            gramPanchayat: 'Phek South GP',
            policeStationPostOffice: 'Phek Rural PS',
          ),
        ],
      },
      'Shamator': {

        'Shamator City': [
          const VillageRecord(
            villageName: 'Shamator Rural',
            lgdCode: '501386',
            gramPanchayat: 'Shamator GP',
            policeStationPostOffice: 'Shamator PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shamator North',
            lgdCode: '501387',
            gramPanchayat: 'Shamator Ward 1',
            policeStationPostOffice: 'Shamator PS / PO',
          ),
        ],
        'Shamator Block': [
          const VillageRecord(
            villageName: 'Shamator East',
            lgdCode: '501388',
            gramPanchayat: 'Shamator East GP',
            policeStationPostOffice: 'Shamator Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shamator South',
            lgdCode: '501389',
            gramPanchayat: 'Shamator South GP',
            policeStationPostOffice: 'Shamator Rural PS',
          ),
        ],
      },
      'Tseminyu': {

        'Tseminyu City': [
          const VillageRecord(
            villageName: 'Tseminyu Rural',
            lgdCode: '501390',
            gramPanchayat: 'Tseminyu GP',
            policeStationPostOffice: 'Tseminyu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tseminyu North',
            lgdCode: '501391',
            gramPanchayat: 'Tseminyu Ward 1',
            policeStationPostOffice: 'Tseminyu PS / PO',
          ),
        ],
        'Tseminyu Block': [
          const VillageRecord(
            villageName: 'Tseminyu East',
            lgdCode: '501392',
            gramPanchayat: 'Tseminyu East GP',
            policeStationPostOffice: 'Tseminyu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tseminyu South',
            lgdCode: '501393',
            gramPanchayat: 'Tseminyu South GP',
            policeStationPostOffice: 'Tseminyu Rural PS',
          ),
        ],
      },
      'Tuensang': {

        'Tuensang City': [
          const VillageRecord(
            villageName: 'Tuensang Rural',
            lgdCode: '501394',
            gramPanchayat: 'Tuensang GP',
            policeStationPostOffice: 'Tuensang PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tuensang North',
            lgdCode: '501395',
            gramPanchayat: 'Tuensang Ward 1',
            policeStationPostOffice: 'Tuensang PS / PO',
          ),
        ],
        'Tuensang Block': [
          const VillageRecord(
            villageName: 'Tuensang East',
            lgdCode: '501396',
            gramPanchayat: 'Tuensang East GP',
            policeStationPostOffice: 'Tuensang Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tuensang South',
            lgdCode: '501397',
            gramPanchayat: 'Tuensang South GP',
            policeStationPostOffice: 'Tuensang Rural PS',
          ),
        ],
      },
      'Wokha': {

        'Wokha City': [
          const VillageRecord(
            villageName: 'Wokha Rural',
            lgdCode: '501398',
            gramPanchayat: 'Wokha GP',
            policeStationPostOffice: 'Wokha PS / PO',
          ),
          const VillageRecord(
            villageName: 'Wokha North',
            lgdCode: '501399',
            gramPanchayat: 'Wokha Ward 1',
            policeStationPostOffice: 'Wokha PS / PO',
          ),
        ],
        'Wokha Block': [
          const VillageRecord(
            villageName: 'Wokha East',
            lgdCode: '501400',
            gramPanchayat: 'Wokha East GP',
            policeStationPostOffice: 'Wokha Rural PS',
          ),
          const VillageRecord(
            villageName: 'Wokha South',
            lgdCode: '501401',
            gramPanchayat: 'Wokha South GP',
            policeStationPostOffice: 'Wokha Rural PS',
          ),
        ],
      },
      'Zunheboto': {

        'Zunheboto City': [
          const VillageRecord(
            villageName: 'Zunheboto Rural',
            lgdCode: '501402',
            gramPanchayat: 'Zunheboto GP',
            policeStationPostOffice: 'Zunheboto PS / PO',
          ),
          const VillageRecord(
            villageName: 'Zunheboto North',
            lgdCode: '501403',
            gramPanchayat: 'Zunheboto Ward 1',
            policeStationPostOffice: 'Zunheboto PS / PO',
          ),
        ],
        'Zunheboto Block': [
          const VillageRecord(
            villageName: 'Zunheboto East',
            lgdCode: '501404',
            gramPanchayat: 'Zunheboto East GP',
            policeStationPostOffice: 'Zunheboto Rural PS',
          ),
          const VillageRecord(
            villageName: 'Zunheboto South',
            lgdCode: '501405',
            gramPanchayat: 'Zunheboto South GP',
            policeStationPostOffice: 'Zunheboto Rural PS',
          ),
        ],
      },
    },
    'Odisha': {
      'Angul': {

        'Angul City': [
          const VillageRecord(
            villageName: 'Angul Rural',
            lgdCode: '501406',
            gramPanchayat: 'Angul GP',
            policeStationPostOffice: 'Angul PS / PO',
          ),
          const VillageRecord(
            villageName: 'Angul North',
            lgdCode: '501407',
            gramPanchayat: 'Angul Ward 1',
            policeStationPostOffice: 'Angul PS / PO',
          ),
        ],
        'Angul Block': [
          const VillageRecord(
            villageName: 'Angul East',
            lgdCode: '501408',
            gramPanchayat: 'Angul East GP',
            policeStationPostOffice: 'Angul Rural PS',
          ),
          const VillageRecord(
            villageName: 'Angul South',
            lgdCode: '501409',
            gramPanchayat: 'Angul South GP',
            policeStationPostOffice: 'Angul Rural PS',
          ),
        ],
      },
      'Balangir': {

        'Balangir City': [
          const VillageRecord(
            villageName: 'Balangir Rural',
            lgdCode: '501410',
            gramPanchayat: 'Balangir GP',
            policeStationPostOffice: 'Balangir PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balangir North',
            lgdCode: '501411',
            gramPanchayat: 'Balangir Ward 1',
            policeStationPostOffice: 'Balangir PS / PO',
          ),
        ],
        'Balangir Block': [
          const VillageRecord(
            villageName: 'Balangir East',
            lgdCode: '501412',
            gramPanchayat: 'Balangir East GP',
            policeStationPostOffice: 'Balangir Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balangir South',
            lgdCode: '501413',
            gramPanchayat: 'Balangir South GP',
            policeStationPostOffice: 'Balangir Rural PS',
          ),
        ],
      },
      'Balasore': {

        'Balasore City': [
          const VillageRecord(
            villageName: 'Balasore Rural',
            lgdCode: '501414',
            gramPanchayat: 'Balasore GP',
            policeStationPostOffice: 'Balasore PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balasore North',
            lgdCode: '501415',
            gramPanchayat: 'Balasore Ward 1',
            policeStationPostOffice: 'Balasore PS / PO',
          ),
        ],
        'Balasore Block': [
          const VillageRecord(
            villageName: 'Balasore East',
            lgdCode: '501416',
            gramPanchayat: 'Balasore East GP',
            policeStationPostOffice: 'Balasore Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balasore South',
            lgdCode: '501417',
            gramPanchayat: 'Balasore South GP',
            policeStationPostOffice: 'Balasore Rural PS',
          ),
        ],
      },
      'Bargarh': {

        'Bargarh City': [
          const VillageRecord(
            villageName: 'Bargarh Rural',
            lgdCode: '501418',
            gramPanchayat: 'Bargarh GP',
            policeStationPostOffice: 'Bargarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bargarh North',
            lgdCode: '501419',
            gramPanchayat: 'Bargarh Ward 1',
            policeStationPostOffice: 'Bargarh PS / PO',
          ),
        ],
        'Bargarh Block': [
          const VillageRecord(
            villageName: 'Bargarh East',
            lgdCode: '501420',
            gramPanchayat: 'Bargarh East GP',
            policeStationPostOffice: 'Bargarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bargarh South',
            lgdCode: '501421',
            gramPanchayat: 'Bargarh South GP',
            policeStationPostOffice: 'Bargarh Rural PS',
          ),
        ],
      },
      'Bhadrak': {

        'Bhadrak City': [
          const VillageRecord(
            villageName: 'Bhadrak Rural',
            lgdCode: '501422',
            gramPanchayat: 'Bhadrak GP',
            policeStationPostOffice: 'Bhadrak PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhadrak North',
            lgdCode: '501423',
            gramPanchayat: 'Bhadrak Ward 1',
            policeStationPostOffice: 'Bhadrak PS / PO',
          ),
        ],
        'Bhadrak Block': [
          const VillageRecord(
            villageName: 'Bhadrak East',
            lgdCode: '501424',
            gramPanchayat: 'Bhadrak East GP',
            policeStationPostOffice: 'Bhadrak Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhadrak South',
            lgdCode: '501425',
            gramPanchayat: 'Bhadrak South GP',
            policeStationPostOffice: 'Bhadrak Rural PS',
          ),
        ],
      },
      'Boudh': {

        'Boudh City': [
          const VillageRecord(
            villageName: 'Boudh Rural',
            lgdCode: '501426',
            gramPanchayat: 'Boudh GP',
            policeStationPostOffice: 'Boudh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Boudh North',
            lgdCode: '501427',
            gramPanchayat: 'Boudh Ward 1',
            policeStationPostOffice: 'Boudh PS / PO',
          ),
        ],
        'Boudh Block': [
          const VillageRecord(
            villageName: 'Boudh East',
            lgdCode: '501428',
            gramPanchayat: 'Boudh East GP',
            policeStationPostOffice: 'Boudh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Boudh South',
            lgdCode: '501429',
            gramPanchayat: 'Boudh South GP',
            policeStationPostOffice: 'Boudh Rural PS',
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
      'Deogarh': {

        'Deogarh City': [
          const VillageRecord(
            villageName: 'Deogarh Rural',
            lgdCode: '501430',
            gramPanchayat: 'Deogarh GP',
            policeStationPostOffice: 'Deogarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Deogarh North',
            lgdCode: '501431',
            gramPanchayat: 'Deogarh Ward 1',
            policeStationPostOffice: 'Deogarh PS / PO',
          ),
        ],
        'Deogarh Block': [
          const VillageRecord(
            villageName: 'Deogarh East',
            lgdCode: '501432',
            gramPanchayat: 'Deogarh East GP',
            policeStationPostOffice: 'Deogarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Deogarh South',
            lgdCode: '501433',
            gramPanchayat: 'Deogarh South GP',
            policeStationPostOffice: 'Deogarh Rural PS',
          ),
        ],
      },
      'Dhenkanal': {

        'Dhenkanal City': [
          const VillageRecord(
            villageName: 'Dhenkanal Rural',
            lgdCode: '501434',
            gramPanchayat: 'Dhenkanal GP',
            policeStationPostOffice: 'Dhenkanal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dhenkanal North',
            lgdCode: '501435',
            gramPanchayat: 'Dhenkanal Ward 1',
            policeStationPostOffice: 'Dhenkanal PS / PO',
          ),
        ],
        'Dhenkanal Block': [
          const VillageRecord(
            villageName: 'Dhenkanal East',
            lgdCode: '501436',
            gramPanchayat: 'Dhenkanal East GP',
            policeStationPostOffice: 'Dhenkanal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dhenkanal South',
            lgdCode: '501437',
            gramPanchayat: 'Dhenkanal South GP',
            policeStationPostOffice: 'Dhenkanal Rural PS',
          ),
        ],
      },
      'Gajapati': {

        'Gajapati City': [
          const VillageRecord(
            villageName: 'Gajapati Rural',
            lgdCode: '501438',
            gramPanchayat: 'Gajapati GP',
            policeStationPostOffice: 'Gajapati PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gajapati North',
            lgdCode: '501439',
            gramPanchayat: 'Gajapati Ward 1',
            policeStationPostOffice: 'Gajapati PS / PO',
          ),
        ],
        'Gajapati Block': [
          const VillageRecord(
            villageName: 'Gajapati East',
            lgdCode: '501440',
            gramPanchayat: 'Gajapati East GP',
            policeStationPostOffice: 'Gajapati Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gajapati South',
            lgdCode: '501441',
            gramPanchayat: 'Gajapati South GP',
            policeStationPostOffice: 'Gajapati Rural PS',
          ),
        ],
      },
      'Ganjam': {

        'Ganjam City': [
          const VillageRecord(
            villageName: 'Ganjam Rural',
            lgdCode: '501442',
            gramPanchayat: 'Ganjam GP',
            policeStationPostOffice: 'Ganjam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ganjam North',
            lgdCode: '501443',
            gramPanchayat: 'Ganjam Ward 1',
            policeStationPostOffice: 'Ganjam PS / PO',
          ),
        ],
        'Ganjam Block': [
          const VillageRecord(
            villageName: 'Ganjam East',
            lgdCode: '501444',
            gramPanchayat: 'Ganjam East GP',
            policeStationPostOffice: 'Ganjam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ganjam South',
            lgdCode: '501445',
            gramPanchayat: 'Ganjam South GP',
            policeStationPostOffice: 'Ganjam Rural PS',
          ),
        ],
      },
      'Jagatsinghpur': {

        'Jagatsinghpur City': [
          const VillageRecord(
            villageName: 'Jagatsinghpur Rural',
            lgdCode: '501446',
            gramPanchayat: 'Jagatsinghpur GP',
            policeStationPostOffice: 'Jagatsinghpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jagatsinghpur North',
            lgdCode: '501447',
            gramPanchayat: 'Jagatsinghpur Ward 1',
            policeStationPostOffice: 'Jagatsinghpur PS / PO',
          ),
        ],
        'Jagatsinghpur Block': [
          const VillageRecord(
            villageName: 'Jagatsinghpur East',
            lgdCode: '501448',
            gramPanchayat: 'Jagatsinghpur East GP',
            policeStationPostOffice: 'Jagatsinghpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jagatsinghpur South',
            lgdCode: '501449',
            gramPanchayat: 'Jagatsinghpur South GP',
            policeStationPostOffice: 'Jagatsinghpur Rural PS',
          ),
        ],
      },
      'Jajpur': {

        'Jajpur City': [
          const VillageRecord(
            villageName: 'Jajpur Rural',
            lgdCode: '501450',
            gramPanchayat: 'Jajpur GP',
            policeStationPostOffice: 'Jajpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jajpur North',
            lgdCode: '501451',
            gramPanchayat: 'Jajpur Ward 1',
            policeStationPostOffice: 'Jajpur PS / PO',
          ),
        ],
        'Jajpur Block': [
          const VillageRecord(
            villageName: 'Jajpur East',
            lgdCode: '501452',
            gramPanchayat: 'Jajpur East GP',
            policeStationPostOffice: 'Jajpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jajpur South',
            lgdCode: '501453',
            gramPanchayat: 'Jajpur South GP',
            policeStationPostOffice: 'Jajpur Rural PS',
          ),
        ],
      },
      'Jharsuguda': {

        'Jharsuguda City': [
          const VillageRecord(
            villageName: 'Jharsuguda Rural',
            lgdCode: '501454',
            gramPanchayat: 'Jharsuguda GP',
            policeStationPostOffice: 'Jharsuguda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jharsuguda North',
            lgdCode: '501455',
            gramPanchayat: 'Jharsuguda Ward 1',
            policeStationPostOffice: 'Jharsuguda PS / PO',
          ),
        ],
        'Jharsuguda Block': [
          const VillageRecord(
            villageName: 'Jharsuguda East',
            lgdCode: '501456',
            gramPanchayat: 'Jharsuguda East GP',
            policeStationPostOffice: 'Jharsuguda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jharsuguda South',
            lgdCode: '501457',
            gramPanchayat: 'Jharsuguda South GP',
            policeStationPostOffice: 'Jharsuguda Rural PS',
          ),
        ],
      },
      'Kalahandi': {

        'Kalahandi City': [
          const VillageRecord(
            villageName: 'Kalahandi Rural',
            lgdCode: '501458',
            gramPanchayat: 'Kalahandi GP',
            policeStationPostOffice: 'Kalahandi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kalahandi North',
            lgdCode: '501459',
            gramPanchayat: 'Kalahandi Ward 1',
            policeStationPostOffice: 'Kalahandi PS / PO',
          ),
        ],
        'Kalahandi Block': [
          const VillageRecord(
            villageName: 'Kalahandi East',
            lgdCode: '501460',
            gramPanchayat: 'Kalahandi East GP',
            policeStationPostOffice: 'Kalahandi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kalahandi South',
            lgdCode: '501461',
            gramPanchayat: 'Kalahandi South GP',
            policeStationPostOffice: 'Kalahandi Rural PS',
          ),
        ],
      },
      'Kandhamal': {

        'Kandhamal City': [
          const VillageRecord(
            villageName: 'Kandhamal Rural',
            lgdCode: '501462',
            gramPanchayat: 'Kandhamal GP',
            policeStationPostOffice: 'Kandhamal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kandhamal North',
            lgdCode: '501463',
            gramPanchayat: 'Kandhamal Ward 1',
            policeStationPostOffice: 'Kandhamal PS / PO',
          ),
        ],
        'Kandhamal Block': [
          const VillageRecord(
            villageName: 'Kandhamal East',
            lgdCode: '501464',
            gramPanchayat: 'Kandhamal East GP',
            policeStationPostOffice: 'Kandhamal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kandhamal South',
            lgdCode: '501465',
            gramPanchayat: 'Kandhamal South GP',
            policeStationPostOffice: 'Kandhamal Rural PS',
          ),
        ],
      },
      'Kendrapara': {

        'Kendrapara City': [
          const VillageRecord(
            villageName: 'Kendrapara Rural',
            lgdCode: '501466',
            gramPanchayat: 'Kendrapara GP',
            policeStationPostOffice: 'Kendrapara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kendrapara North',
            lgdCode: '501467',
            gramPanchayat: 'Kendrapara Ward 1',
            policeStationPostOffice: 'Kendrapara PS / PO',
          ),
        ],
        'Kendrapara Block': [
          const VillageRecord(
            villageName: 'Kendrapara East',
            lgdCode: '501468',
            gramPanchayat: 'Kendrapara East GP',
            policeStationPostOffice: 'Kendrapara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kendrapara South',
            lgdCode: '501469',
            gramPanchayat: 'Kendrapara South GP',
            policeStationPostOffice: 'Kendrapara Rural PS',
          ),
        ],
      },
      'Kendujhar': {

        'Kendujhar City': [
          const VillageRecord(
            villageName: 'Kendujhar Rural',
            lgdCode: '501470',
            gramPanchayat: 'Kendujhar GP',
            policeStationPostOffice: 'Kendujhar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kendujhar North',
            lgdCode: '501471',
            gramPanchayat: 'Kendujhar Ward 1',
            policeStationPostOffice: 'Kendujhar PS / PO',
          ),
        ],
        'Kendujhar Block': [
          const VillageRecord(
            villageName: 'Kendujhar East',
            lgdCode: '501472',
            gramPanchayat: 'Kendujhar East GP',
            policeStationPostOffice: 'Kendujhar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kendujhar South',
            lgdCode: '501473',
            gramPanchayat: 'Kendujhar South GP',
            policeStationPostOffice: 'Kendujhar Rural PS',
          ),
        ],
      },
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
      'Koraput': {

        'Koraput City': [
          const VillageRecord(
            villageName: 'Koraput Rural',
            lgdCode: '501474',
            gramPanchayat: 'Koraput GP',
            policeStationPostOffice: 'Koraput PS / PO',
          ),
          const VillageRecord(
            villageName: 'Koraput North',
            lgdCode: '501475',
            gramPanchayat: 'Koraput Ward 1',
            policeStationPostOffice: 'Koraput PS / PO',
          ),
        ],
        'Koraput Block': [
          const VillageRecord(
            villageName: 'Koraput East',
            lgdCode: '501476',
            gramPanchayat: 'Koraput East GP',
            policeStationPostOffice: 'Koraput Rural PS',
          ),
          const VillageRecord(
            villageName: 'Koraput South',
            lgdCode: '501477',
            gramPanchayat: 'Koraput South GP',
            policeStationPostOffice: 'Koraput Rural PS',
          ),
        ],
      },
      'Malkangiri': {

        'Malkangiri City': [
          const VillageRecord(
            villageName: 'Malkangiri Rural',
            lgdCode: '501478',
            gramPanchayat: 'Malkangiri GP',
            policeStationPostOffice: 'Malkangiri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Malkangiri North',
            lgdCode: '501479',
            gramPanchayat: 'Malkangiri Ward 1',
            policeStationPostOffice: 'Malkangiri PS / PO',
          ),
        ],
        'Malkangiri Block': [
          const VillageRecord(
            villageName: 'Malkangiri East',
            lgdCode: '501480',
            gramPanchayat: 'Malkangiri East GP',
            policeStationPostOffice: 'Malkangiri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Malkangiri South',
            lgdCode: '501481',
            gramPanchayat: 'Malkangiri South GP',
            policeStationPostOffice: 'Malkangiri Rural PS',
          ),
        ],
      },
      'Mayurbhanj': {

        'Mayurbhanj City': [
          const VillageRecord(
            villageName: 'Mayurbhanj Rural',
            lgdCode: '501482',
            gramPanchayat: 'Mayurbhanj GP',
            policeStationPostOffice: 'Mayurbhanj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mayurbhanj North',
            lgdCode: '501483',
            gramPanchayat: 'Mayurbhanj Ward 1',
            policeStationPostOffice: 'Mayurbhanj PS / PO',
          ),
        ],
        'Mayurbhanj Block': [
          const VillageRecord(
            villageName: 'Mayurbhanj East',
            lgdCode: '501484',
            gramPanchayat: 'Mayurbhanj East GP',
            policeStationPostOffice: 'Mayurbhanj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mayurbhanj South',
            lgdCode: '501485',
            gramPanchayat: 'Mayurbhanj South GP',
            policeStationPostOffice: 'Mayurbhanj Rural PS',
          ),
        ],
      },
      'Nabarangpur': {

        'Nabarangpur City': [
          const VillageRecord(
            villageName: 'Nabarangpur Rural',
            lgdCode: '501486',
            gramPanchayat: 'Nabarangpur GP',
            policeStationPostOffice: 'Nabarangpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nabarangpur North',
            lgdCode: '501487',
            gramPanchayat: 'Nabarangpur Ward 1',
            policeStationPostOffice: 'Nabarangpur PS / PO',
          ),
        ],
        'Nabarangpur Block': [
          const VillageRecord(
            villageName: 'Nabarangpur East',
            lgdCode: '501488',
            gramPanchayat: 'Nabarangpur East GP',
            policeStationPostOffice: 'Nabarangpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nabarangpur South',
            lgdCode: '501489',
            gramPanchayat: 'Nabarangpur South GP',
            policeStationPostOffice: 'Nabarangpur Rural PS',
          ),
        ],
      },
      'Nayagarh': {

        'Nayagarh City': [
          const VillageRecord(
            villageName: 'Nayagarh Rural',
            lgdCode: '501490',
            gramPanchayat: 'Nayagarh GP',
            policeStationPostOffice: 'Nayagarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nayagarh North',
            lgdCode: '501491',
            gramPanchayat: 'Nayagarh Ward 1',
            policeStationPostOffice: 'Nayagarh PS / PO',
          ),
        ],
        'Nayagarh Block': [
          const VillageRecord(
            villageName: 'Nayagarh East',
            lgdCode: '501492',
            gramPanchayat: 'Nayagarh East GP',
            policeStationPostOffice: 'Nayagarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nayagarh South',
            lgdCode: '501493',
            gramPanchayat: 'Nayagarh South GP',
            policeStationPostOffice: 'Nayagarh Rural PS',
          ),
        ],
      },
      'Nuapada': {

        'Nuapada City': [
          const VillageRecord(
            villageName: 'Nuapada Rural',
            lgdCode: '501494',
            gramPanchayat: 'Nuapada GP',
            policeStationPostOffice: 'Nuapada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nuapada North',
            lgdCode: '501495',
            gramPanchayat: 'Nuapada Ward 1',
            policeStationPostOffice: 'Nuapada PS / PO',
          ),
        ],
        'Nuapada Block': [
          const VillageRecord(
            villageName: 'Nuapada East',
            lgdCode: '501496',
            gramPanchayat: 'Nuapada East GP',
            policeStationPostOffice: 'Nuapada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nuapada South',
            lgdCode: '501497',
            gramPanchayat: 'Nuapada South GP',
            policeStationPostOffice: 'Nuapada Rural PS',
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
      'Rayagada': {

        'Rayagada City': [
          const VillageRecord(
            villageName: 'Rayagada Rural',
            lgdCode: '501498',
            gramPanchayat: 'Rayagada GP',
            policeStationPostOffice: 'Rayagada PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rayagada North',
            lgdCode: '501499',
            gramPanchayat: 'Rayagada Ward 1',
            policeStationPostOffice: 'Rayagada PS / PO',
          ),
        ],
        'Rayagada Block': [
          const VillageRecord(
            villageName: 'Rayagada East',
            lgdCode: '501500',
            gramPanchayat: 'Rayagada East GP',
            policeStationPostOffice: 'Rayagada Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rayagada South',
            lgdCode: '501501',
            gramPanchayat: 'Rayagada South GP',
            policeStationPostOffice: 'Rayagada Rural PS',
          ),
        ],
      },
      'Sambalpur': {

        'Sambalpur City': [
          const VillageRecord(
            villageName: 'Sambalpur Rural',
            lgdCode: '501502',
            gramPanchayat: 'Sambalpur GP',
            policeStationPostOffice: 'Sambalpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sambalpur North',
            lgdCode: '501503',
            gramPanchayat: 'Sambalpur Ward 1',
            policeStationPostOffice: 'Sambalpur PS / PO',
          ),
        ],
        'Sambalpur Block': [
          const VillageRecord(
            villageName: 'Sambalpur East',
            lgdCode: '501504',
            gramPanchayat: 'Sambalpur East GP',
            policeStationPostOffice: 'Sambalpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sambalpur South',
            lgdCode: '501505',
            gramPanchayat: 'Sambalpur South GP',
            policeStationPostOffice: 'Sambalpur Rural PS',
          ),
        ],
      },
      'Subarnapur': {

        'Subarnapur City': [
          const VillageRecord(
            villageName: 'Subarnapur Rural',
            lgdCode: '501506',
            gramPanchayat: 'Subarnapur GP',
            policeStationPostOffice: 'Subarnapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Subarnapur North',
            lgdCode: '501507',
            gramPanchayat: 'Subarnapur Ward 1',
            policeStationPostOffice: 'Subarnapur PS / PO',
          ),
        ],
        'Subarnapur Block': [
          const VillageRecord(
            villageName: 'Subarnapur East',
            lgdCode: '501508',
            gramPanchayat: 'Subarnapur East GP',
            policeStationPostOffice: 'Subarnapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Subarnapur South',
            lgdCode: '501509',
            gramPanchayat: 'Subarnapur South GP',
            policeStationPostOffice: 'Subarnapur Rural PS',
          ),
        ],
      },
      'Sundargarh': {

        'Sundargarh City': [
          const VillageRecord(
            villageName: 'Sundargarh Rural',
            lgdCode: '501510',
            gramPanchayat: 'Sundargarh GP',
            policeStationPostOffice: 'Sundargarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sundargarh North',
            lgdCode: '501511',
            gramPanchayat: 'Sundargarh Ward 1',
            policeStationPostOffice: 'Sundargarh PS / PO',
          ),
        ],
        'Sundargarh Block': [
          const VillageRecord(
            villageName: 'Sundargarh East',
            lgdCode: '501512',
            gramPanchayat: 'Sundargarh East GP',
            policeStationPostOffice: 'Sundargarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sundargarh South',
            lgdCode: '501513',
            gramPanchayat: 'Sundargarh South GP',
            policeStationPostOffice: 'Sundargarh Rural PS',
          ),
        ],
      },
    },
    'Punjab': {
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
      'Barnala': {

        'Barnala City': [
          const VillageRecord(
            villageName: 'Barnala Rural',
            lgdCode: '501514',
            gramPanchayat: 'Barnala GP',
            policeStationPostOffice: 'Barnala PS / PO',
          ),
          const VillageRecord(
            villageName: 'Barnala North',
            lgdCode: '501515',
            gramPanchayat: 'Barnala Ward 1',
            policeStationPostOffice: 'Barnala PS / PO',
          ),
        ],
        'Barnala Block': [
          const VillageRecord(
            villageName: 'Barnala East',
            lgdCode: '501516',
            gramPanchayat: 'Barnala East GP',
            policeStationPostOffice: 'Barnala Rural PS',
          ),
          const VillageRecord(
            villageName: 'Barnala South',
            lgdCode: '501517',
            gramPanchayat: 'Barnala South GP',
            policeStationPostOffice: 'Barnala Rural PS',
          ),
        ],
      },
      'Bathinda': {

        'Bathinda City': [
          const VillageRecord(
            villageName: 'Bathinda Rural',
            lgdCode: '501518',
            gramPanchayat: 'Bathinda GP',
            policeStationPostOffice: 'Bathinda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bathinda North',
            lgdCode: '501519',
            gramPanchayat: 'Bathinda Ward 1',
            policeStationPostOffice: 'Bathinda PS / PO',
          ),
        ],
        'Bathinda Block': [
          const VillageRecord(
            villageName: 'Bathinda East',
            lgdCode: '501520',
            gramPanchayat: 'Bathinda East GP',
            policeStationPostOffice: 'Bathinda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bathinda South',
            lgdCode: '501521',
            gramPanchayat: 'Bathinda South GP',
            policeStationPostOffice: 'Bathinda Rural PS',
          ),
        ],
      },
      'Faridkot': {

        'Faridkot City': [
          const VillageRecord(
            villageName: 'Faridkot Rural',
            lgdCode: '501522',
            gramPanchayat: 'Faridkot GP',
            policeStationPostOffice: 'Faridkot PS / PO',
          ),
          const VillageRecord(
            villageName: 'Faridkot North',
            lgdCode: '501523',
            gramPanchayat: 'Faridkot Ward 1',
            policeStationPostOffice: 'Faridkot PS / PO',
          ),
        ],
        'Faridkot Block': [
          const VillageRecord(
            villageName: 'Faridkot East',
            lgdCode: '501524',
            gramPanchayat: 'Faridkot East GP',
            policeStationPostOffice: 'Faridkot Rural PS',
          ),
          const VillageRecord(
            villageName: 'Faridkot South',
            lgdCode: '501525',
            gramPanchayat: 'Faridkot South GP',
            policeStationPostOffice: 'Faridkot Rural PS',
          ),
        ],
      },
      'Fatehgarh Sahib': {

        'Fatehgarh Sahib City': [
          const VillageRecord(
            villageName: 'Fatehgarh Sahib Rural',
            lgdCode: '501526',
            gramPanchayat: 'Fatehgarh Sahib GP',
            policeStationPostOffice: 'Fatehgarh Sahib PS / PO',
          ),
          const VillageRecord(
            villageName: 'Fatehgarh Sahib North',
            lgdCode: '501527',
            gramPanchayat: 'Fatehgarh Sahib Ward 1',
            policeStationPostOffice: 'Fatehgarh Sahib PS / PO',
          ),
        ],
        'Fatehgarh Sahib Block': [
          const VillageRecord(
            villageName: 'Fatehgarh Sahib East',
            lgdCode: '501528',
            gramPanchayat: 'Fatehgarh Sahib East GP',
            policeStationPostOffice: 'Fatehgarh Sahib Rural PS',
          ),
          const VillageRecord(
            villageName: 'Fatehgarh Sahib South',
            lgdCode: '501529',
            gramPanchayat: 'Fatehgarh Sahib South GP',
            policeStationPostOffice: 'Fatehgarh Sahib Rural PS',
          ),
        ],
      },
      'Fazilka': {

        'Fazilka City': [
          const VillageRecord(
            villageName: 'Fazilka Rural',
            lgdCode: '501530',
            gramPanchayat: 'Fazilka GP',
            policeStationPostOffice: 'Fazilka PS / PO',
          ),
          const VillageRecord(
            villageName: 'Fazilka North',
            lgdCode: '501531',
            gramPanchayat: 'Fazilka Ward 1',
            policeStationPostOffice: 'Fazilka PS / PO',
          ),
        ],
        'Fazilka Block': [
          const VillageRecord(
            villageName: 'Fazilka East',
            lgdCode: '501532',
            gramPanchayat: 'Fazilka East GP',
            policeStationPostOffice: 'Fazilka Rural PS',
          ),
          const VillageRecord(
            villageName: 'Fazilka South',
            lgdCode: '501533',
            gramPanchayat: 'Fazilka South GP',
            policeStationPostOffice: 'Fazilka Rural PS',
          ),
        ],
      },
      'Ferozepur': {

        'Ferozepur City': [
          const VillageRecord(
            villageName: 'Ferozepur Rural',
            lgdCode: '501534',
            gramPanchayat: 'Ferozepur GP',
            policeStationPostOffice: 'Ferozepur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ferozepur North',
            lgdCode: '501535',
            gramPanchayat: 'Ferozepur Ward 1',
            policeStationPostOffice: 'Ferozepur PS / PO',
          ),
        ],
        'Ferozepur Block': [
          const VillageRecord(
            villageName: 'Ferozepur East',
            lgdCode: '501536',
            gramPanchayat: 'Ferozepur East GP',
            policeStationPostOffice: 'Ferozepur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ferozepur South',
            lgdCode: '501537',
            gramPanchayat: 'Ferozepur South GP',
            policeStationPostOffice: 'Ferozepur Rural PS',
          ),
        ],
      },
      'Gurdaspur': {

        'Gurdaspur City': [
          const VillageRecord(
            villageName: 'Gurdaspur Rural',
            lgdCode: '501538',
            gramPanchayat: 'Gurdaspur GP',
            policeStationPostOffice: 'Gurdaspur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gurdaspur North',
            lgdCode: '501539',
            gramPanchayat: 'Gurdaspur Ward 1',
            policeStationPostOffice: 'Gurdaspur PS / PO',
          ),
        ],
        'Gurdaspur Block': [
          const VillageRecord(
            villageName: 'Gurdaspur East',
            lgdCode: '501540',
            gramPanchayat: 'Gurdaspur East GP',
            policeStationPostOffice: 'Gurdaspur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gurdaspur South',
            lgdCode: '501541',
            gramPanchayat: 'Gurdaspur South GP',
            policeStationPostOffice: 'Gurdaspur Rural PS',
          ),
        ],
      },
      'Hoshiarpur': {

        'Hoshiarpur City': [
          const VillageRecord(
            villageName: 'Hoshiarpur Rural',
            lgdCode: '501542',
            gramPanchayat: 'Hoshiarpur GP',
            policeStationPostOffice: 'Hoshiarpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hoshiarpur North',
            lgdCode: '501543',
            gramPanchayat: 'Hoshiarpur Ward 1',
            policeStationPostOffice: 'Hoshiarpur PS / PO',
          ),
        ],
        'Hoshiarpur Block': [
          const VillageRecord(
            villageName: 'Hoshiarpur East',
            lgdCode: '501544',
            gramPanchayat: 'Hoshiarpur East GP',
            policeStationPostOffice: 'Hoshiarpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hoshiarpur South',
            lgdCode: '501545',
            gramPanchayat: 'Hoshiarpur South GP',
            policeStationPostOffice: 'Hoshiarpur Rural PS',
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
      'Kapurthala': {

        'Kapurthala City': [
          const VillageRecord(
            villageName: 'Kapurthala Rural',
            lgdCode: '501546',
            gramPanchayat: 'Kapurthala GP',
            policeStationPostOffice: 'Kapurthala PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kapurthala North',
            lgdCode: '501547',
            gramPanchayat: 'Kapurthala Ward 1',
            policeStationPostOffice: 'Kapurthala PS / PO',
          ),
        ],
        'Kapurthala Block': [
          const VillageRecord(
            villageName: 'Kapurthala East',
            lgdCode: '501548',
            gramPanchayat: 'Kapurthala East GP',
            policeStationPostOffice: 'Kapurthala Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kapurthala South',
            lgdCode: '501549',
            gramPanchayat: 'Kapurthala South GP',
            policeStationPostOffice: 'Kapurthala Rural PS',
          ),
        ],
      },
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
      'Malerkotla': {

        'Malerkotla City': [
          const VillageRecord(
            villageName: 'Malerkotla Rural',
            lgdCode: '501550',
            gramPanchayat: 'Malerkotla GP',
            policeStationPostOffice: 'Malerkotla PS / PO',
          ),
          const VillageRecord(
            villageName: 'Malerkotla North',
            lgdCode: '501551',
            gramPanchayat: 'Malerkotla Ward 1',
            policeStationPostOffice: 'Malerkotla PS / PO',
          ),
        ],
        'Malerkotla Block': [
          const VillageRecord(
            villageName: 'Malerkotla East',
            lgdCode: '501552',
            gramPanchayat: 'Malerkotla East GP',
            policeStationPostOffice: 'Malerkotla Rural PS',
          ),
          const VillageRecord(
            villageName: 'Malerkotla South',
            lgdCode: '501553',
            gramPanchayat: 'Malerkotla South GP',
            policeStationPostOffice: 'Malerkotla Rural PS',
          ),
        ],
      },
      'Mansa': {

        'Mansa City': [
          const VillageRecord(
            villageName: 'Mansa Rural',
            lgdCode: '501554',
            gramPanchayat: 'Mansa GP',
            policeStationPostOffice: 'Mansa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mansa North',
            lgdCode: '501555',
            gramPanchayat: 'Mansa Ward 1',
            policeStationPostOffice: 'Mansa PS / PO',
          ),
        ],
        'Mansa Block': [
          const VillageRecord(
            villageName: 'Mansa East',
            lgdCode: '501556',
            gramPanchayat: 'Mansa East GP',
            policeStationPostOffice: 'Mansa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mansa South',
            lgdCode: '501557',
            gramPanchayat: 'Mansa South GP',
            policeStationPostOffice: 'Mansa Rural PS',
          ),
        ],
      },
      'Moga': {

        'Moga City': [
          const VillageRecord(
            villageName: 'Moga Rural',
            lgdCode: '501558',
            gramPanchayat: 'Moga GP',
            policeStationPostOffice: 'Moga PS / PO',
          ),
          const VillageRecord(
            villageName: 'Moga North',
            lgdCode: '501559',
            gramPanchayat: 'Moga Ward 1',
            policeStationPostOffice: 'Moga PS / PO',
          ),
        ],
        'Moga Block': [
          const VillageRecord(
            villageName: 'Moga East',
            lgdCode: '501560',
            gramPanchayat: 'Moga East GP',
            policeStationPostOffice: 'Moga Rural PS',
          ),
          const VillageRecord(
            villageName: 'Moga South',
            lgdCode: '501561',
            gramPanchayat: 'Moga South GP',
            policeStationPostOffice: 'Moga Rural PS',
          ),
        ],
      },
      'Muktsar': {

        'Muktsar City': [
          const VillageRecord(
            villageName: 'Muktsar Rural',
            lgdCode: '501562',
            gramPanchayat: 'Muktsar GP',
            policeStationPostOffice: 'Muktsar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Muktsar North',
            lgdCode: '501563',
            gramPanchayat: 'Muktsar Ward 1',
            policeStationPostOffice: 'Muktsar PS / PO',
          ),
        ],
        'Muktsar Block': [
          const VillageRecord(
            villageName: 'Muktsar East',
            lgdCode: '501564',
            gramPanchayat: 'Muktsar East GP',
            policeStationPostOffice: 'Muktsar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Muktsar South',
            lgdCode: '501565',
            gramPanchayat: 'Muktsar South GP',
            policeStationPostOffice: 'Muktsar Rural PS',
          ),
        ],
      },
      'Pathankot': {

        'Pathankot City': [
          const VillageRecord(
            villageName: 'Pathankot Rural',
            lgdCode: '501566',
            gramPanchayat: 'Pathankot GP',
            policeStationPostOffice: 'Pathankot PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pathankot North',
            lgdCode: '501567',
            gramPanchayat: 'Pathankot Ward 1',
            policeStationPostOffice: 'Pathankot PS / PO',
          ),
        ],
        'Pathankot Block': [
          const VillageRecord(
            villageName: 'Pathankot East',
            lgdCode: '501568',
            gramPanchayat: 'Pathankot East GP',
            policeStationPostOffice: 'Pathankot Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pathankot South',
            lgdCode: '501569',
            gramPanchayat: 'Pathankot South GP',
            policeStationPostOffice: 'Pathankot Rural PS',
          ),
        ],
      },
      'Patiala': {

        'Patiala City': [
          const VillageRecord(
            villageName: 'Patiala Rural',
            lgdCode: '501570',
            gramPanchayat: 'Patiala GP',
            policeStationPostOffice: 'Patiala PS / PO',
          ),
          const VillageRecord(
            villageName: 'Patiala North',
            lgdCode: '501571',
            gramPanchayat: 'Patiala Ward 1',
            policeStationPostOffice: 'Patiala PS / PO',
          ),
        ],
        'Patiala Block': [
          const VillageRecord(
            villageName: 'Patiala East',
            lgdCode: '501572',
            gramPanchayat: 'Patiala East GP',
            policeStationPostOffice: 'Patiala Rural PS',
          ),
          const VillageRecord(
            villageName: 'Patiala South',
            lgdCode: '501573',
            gramPanchayat: 'Patiala South GP',
            policeStationPostOffice: 'Patiala Rural PS',
          ),
        ],
      },
      'Rupnagar': {

        'Rupnagar City': [
          const VillageRecord(
            villageName: 'Rupnagar Rural',
            lgdCode: '501574',
            gramPanchayat: 'Rupnagar GP',
            policeStationPostOffice: 'Rupnagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rupnagar North',
            lgdCode: '501575',
            gramPanchayat: 'Rupnagar Ward 1',
            policeStationPostOffice: 'Rupnagar PS / PO',
          ),
        ],
        'Rupnagar Block': [
          const VillageRecord(
            villageName: 'Rupnagar East',
            lgdCode: '501576',
            gramPanchayat: 'Rupnagar East GP',
            policeStationPostOffice: 'Rupnagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rupnagar South',
            lgdCode: '501577',
            gramPanchayat: 'Rupnagar South GP',
            policeStationPostOffice: 'Rupnagar Rural PS',
          ),
        ],
      },
      'Sahibzada Ajit Singh Nagar (Mohali)': {

        'Sahibzada Ajit Singh Nagar (Mohali) City': [
          const VillageRecord(
            villageName: 'Sahibzada Ajit Singh Nagar (Mohali) Rural',
            lgdCode: '501578',
            gramPanchayat: 'Sahibzada Ajit Singh Nagar (Mohali) GP',
            policeStationPostOffice: 'Sahibzada Ajit Singh Nagar (Mohali) PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sahibzada Ajit Singh Nagar (Mohali) North',
            lgdCode: '501579',
            gramPanchayat: 'Sahibzada Ajit Singh Nagar (Mohali) Ward 1',
            policeStationPostOffice: 'Sahibzada Ajit Singh Nagar (Mohali) PS / PO',
          ),
        ],
        'Sahibzada Ajit Singh Nagar (Mohali) Block': [
          const VillageRecord(
            villageName: 'Sahibzada Ajit Singh Nagar (Mohali) East',
            lgdCode: '501580',
            gramPanchayat: 'Sahibzada Ajit Singh Nagar (Mohali) East GP',
            policeStationPostOffice: 'Sahibzada Ajit Singh Nagar (Mohali) Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sahibzada Ajit Singh Nagar (Mohali) South',
            lgdCode: '501581',
            gramPanchayat: 'Sahibzada Ajit Singh Nagar (Mohali) South GP',
            policeStationPostOffice: 'Sahibzada Ajit Singh Nagar (Mohali) Rural PS',
          ),
        ],
      },
      'Sangrur': {

        'Sangrur City': [
          const VillageRecord(
            villageName: 'Sangrur Rural',
            lgdCode: '501582',
            gramPanchayat: 'Sangrur GP',
            policeStationPostOffice: 'Sangrur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sangrur North',
            lgdCode: '501583',
            gramPanchayat: 'Sangrur Ward 1',
            policeStationPostOffice: 'Sangrur PS / PO',
          ),
        ],
        'Sangrur Block': [
          const VillageRecord(
            villageName: 'Sangrur East',
            lgdCode: '501584',
            gramPanchayat: 'Sangrur East GP',
            policeStationPostOffice: 'Sangrur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sangrur South',
            lgdCode: '501585',
            gramPanchayat: 'Sangrur South GP',
            policeStationPostOffice: 'Sangrur Rural PS',
          ),
        ],
      },
      'Shahid Bhagat Singh Nagar': {

        'Shahid Bhagat Singh Nagar City': [
          const VillageRecord(
            villageName: 'Shahid Bhagat Singh Nagar Rural',
            lgdCode: '501586',
            gramPanchayat: 'Shahid Bhagat Singh Nagar GP',
            policeStationPostOffice: 'Shahid Bhagat Singh Nagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shahid Bhagat Singh Nagar North',
            lgdCode: '501587',
            gramPanchayat: 'Shahid Bhagat Singh Nagar Ward 1',
            policeStationPostOffice: 'Shahid Bhagat Singh Nagar PS / PO',
          ),
        ],
        'Shahid Bhagat Singh Nagar Block': [
          const VillageRecord(
            villageName: 'Shahid Bhagat Singh Nagar East',
            lgdCode: '501588',
            gramPanchayat: 'Shahid Bhagat Singh Nagar East GP',
            policeStationPostOffice: 'Shahid Bhagat Singh Nagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shahid Bhagat Singh Nagar South',
            lgdCode: '501589',
            gramPanchayat: 'Shahid Bhagat Singh Nagar South GP',
            policeStationPostOffice: 'Shahid Bhagat Singh Nagar Rural PS',
          ),
        ],
      },
      'Tarn Taran': {

        'Tarn Taran City': [
          const VillageRecord(
            villageName: 'Tarn Taran Rural',
            lgdCode: '501590',
            gramPanchayat: 'Tarn Taran GP',
            policeStationPostOffice: 'Tarn Taran PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tarn Taran North',
            lgdCode: '501591',
            gramPanchayat: 'Tarn Taran Ward 1',
            policeStationPostOffice: 'Tarn Taran PS / PO',
          ),
        ],
        'Tarn Taran Block': [
          const VillageRecord(
            villageName: 'Tarn Taran East',
            lgdCode: '501592',
            gramPanchayat: 'Tarn Taran East GP',
            policeStationPostOffice: 'Tarn Taran Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tarn Taran South',
            lgdCode: '501593',
            gramPanchayat: 'Tarn Taran South GP',
            policeStationPostOffice: 'Tarn Taran Rural PS',
          ),
        ],
      },
    },
    'Rajasthan': {
      'Ajmer': {

        'Ajmer City': [
          const VillageRecord(
            villageName: 'Ajmer Rural',
            lgdCode: '501594',
            gramPanchayat: 'Ajmer GP',
            policeStationPostOffice: 'Ajmer PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ajmer North',
            lgdCode: '501595',
            gramPanchayat: 'Ajmer Ward 1',
            policeStationPostOffice: 'Ajmer PS / PO',
          ),
        ],
        'Ajmer Block': [
          const VillageRecord(
            villageName: 'Ajmer East',
            lgdCode: '501596',
            gramPanchayat: 'Ajmer East GP',
            policeStationPostOffice: 'Ajmer Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ajmer South',
            lgdCode: '501597',
            gramPanchayat: 'Ajmer South GP',
            policeStationPostOffice: 'Ajmer Rural PS',
          ),
        ],
      },
      'Alwar': {

        'Alwar City': [
          const VillageRecord(
            villageName: 'Alwar Rural',
            lgdCode: '501598',
            gramPanchayat: 'Alwar GP',
            policeStationPostOffice: 'Alwar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Alwar North',
            lgdCode: '501599',
            gramPanchayat: 'Alwar Ward 1',
            policeStationPostOffice: 'Alwar PS / PO',
          ),
        ],
        'Alwar Block': [
          const VillageRecord(
            villageName: 'Alwar East',
            lgdCode: '501600',
            gramPanchayat: 'Alwar East GP',
            policeStationPostOffice: 'Alwar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Alwar South',
            lgdCode: '501601',
            gramPanchayat: 'Alwar South GP',
            policeStationPostOffice: 'Alwar Rural PS',
          ),
        ],
      },
      'Anupgarh': {

        'Anupgarh City': [
          const VillageRecord(
            villageName: 'Anupgarh Rural',
            lgdCode: '501602',
            gramPanchayat: 'Anupgarh GP',
            policeStationPostOffice: 'Anupgarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Anupgarh North',
            lgdCode: '501603',
            gramPanchayat: 'Anupgarh Ward 1',
            policeStationPostOffice: 'Anupgarh PS / PO',
          ),
        ],
        'Anupgarh Block': [
          const VillageRecord(
            villageName: 'Anupgarh East',
            lgdCode: '501604',
            gramPanchayat: 'Anupgarh East GP',
            policeStationPostOffice: 'Anupgarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Anupgarh South',
            lgdCode: '501605',
            gramPanchayat: 'Anupgarh South GP',
            policeStationPostOffice: 'Anupgarh Rural PS',
          ),
        ],
      },
      'Balotra': {

        'Balotra City': [
          const VillageRecord(
            villageName: 'Balotra Rural',
            lgdCode: '501606',
            gramPanchayat: 'Balotra GP',
            policeStationPostOffice: 'Balotra PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balotra North',
            lgdCode: '501607',
            gramPanchayat: 'Balotra Ward 1',
            policeStationPostOffice: 'Balotra PS / PO',
          ),
        ],
        'Balotra Block': [
          const VillageRecord(
            villageName: 'Balotra East',
            lgdCode: '501608',
            gramPanchayat: 'Balotra East GP',
            policeStationPostOffice: 'Balotra Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balotra South',
            lgdCode: '501609',
            gramPanchayat: 'Balotra South GP',
            policeStationPostOffice: 'Balotra Rural PS',
          ),
        ],
      },
      'Banswara': {

        'Banswara City': [
          const VillageRecord(
            villageName: 'Banswara Rural',
            lgdCode: '501610',
            gramPanchayat: 'Banswara GP',
            policeStationPostOffice: 'Banswara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Banswara North',
            lgdCode: '501611',
            gramPanchayat: 'Banswara Ward 1',
            policeStationPostOffice: 'Banswara PS / PO',
          ),
        ],
        'Banswara Block': [
          const VillageRecord(
            villageName: 'Banswara East',
            lgdCode: '501612',
            gramPanchayat: 'Banswara East GP',
            policeStationPostOffice: 'Banswara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Banswara South',
            lgdCode: '501613',
            gramPanchayat: 'Banswara South GP',
            policeStationPostOffice: 'Banswara Rural PS',
          ),
        ],
      },
      'Baran': {

        'Baran City': [
          const VillageRecord(
            villageName: 'Baran Rural',
            lgdCode: '501614',
            gramPanchayat: 'Baran GP',
            policeStationPostOffice: 'Baran PS / PO',
          ),
          const VillageRecord(
            villageName: 'Baran North',
            lgdCode: '501615',
            gramPanchayat: 'Baran Ward 1',
            policeStationPostOffice: 'Baran PS / PO',
          ),
        ],
        'Baran Block': [
          const VillageRecord(
            villageName: 'Baran East',
            lgdCode: '501616',
            gramPanchayat: 'Baran East GP',
            policeStationPostOffice: 'Baran Rural PS',
          ),
          const VillageRecord(
            villageName: 'Baran South',
            lgdCode: '501617',
            gramPanchayat: 'Baran South GP',
            policeStationPostOffice: 'Baran Rural PS',
          ),
        ],
      },
      'Barmer': {

        'Barmer City': [
          const VillageRecord(
            villageName: 'Barmer Rural',
            lgdCode: '501618',
            gramPanchayat: 'Barmer GP',
            policeStationPostOffice: 'Barmer PS / PO',
          ),
          const VillageRecord(
            villageName: 'Barmer North',
            lgdCode: '501619',
            gramPanchayat: 'Barmer Ward 1',
            policeStationPostOffice: 'Barmer PS / PO',
          ),
        ],
        'Barmer Block': [
          const VillageRecord(
            villageName: 'Barmer East',
            lgdCode: '501620',
            gramPanchayat: 'Barmer East GP',
            policeStationPostOffice: 'Barmer Rural PS',
          ),
          const VillageRecord(
            villageName: 'Barmer South',
            lgdCode: '501621',
            gramPanchayat: 'Barmer South GP',
            policeStationPostOffice: 'Barmer Rural PS',
          ),
        ],
      },
      'Beawar': {

        'Beawar City': [
          const VillageRecord(
            villageName: 'Beawar Rural',
            lgdCode: '501622',
            gramPanchayat: 'Beawar GP',
            policeStationPostOffice: 'Beawar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Beawar North',
            lgdCode: '501623',
            gramPanchayat: 'Beawar Ward 1',
            policeStationPostOffice: 'Beawar PS / PO',
          ),
        ],
        'Beawar Block': [
          const VillageRecord(
            villageName: 'Beawar East',
            lgdCode: '501624',
            gramPanchayat: 'Beawar East GP',
            policeStationPostOffice: 'Beawar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Beawar South',
            lgdCode: '501625',
            gramPanchayat: 'Beawar South GP',
            policeStationPostOffice: 'Beawar Rural PS',
          ),
        ],
      },
      'Bharatpur': {

        'Bharatpur City': [
          const VillageRecord(
            villageName: 'Bharatpur Rural',
            lgdCode: '501626',
            gramPanchayat: 'Bharatpur GP',
            policeStationPostOffice: 'Bharatpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bharatpur North',
            lgdCode: '501627',
            gramPanchayat: 'Bharatpur Ward 1',
            policeStationPostOffice: 'Bharatpur PS / PO',
          ),
        ],
        'Bharatpur Block': [
          const VillageRecord(
            villageName: 'Bharatpur East',
            lgdCode: '501628',
            gramPanchayat: 'Bharatpur East GP',
            policeStationPostOffice: 'Bharatpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bharatpur South',
            lgdCode: '501629',
            gramPanchayat: 'Bharatpur South GP',
            policeStationPostOffice: 'Bharatpur Rural PS',
          ),
        ],
      },
      'Bhilwara': {

        'Bhilwara City': [
          const VillageRecord(
            villageName: 'Bhilwara Rural',
            lgdCode: '501630',
            gramPanchayat: 'Bhilwara GP',
            policeStationPostOffice: 'Bhilwara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhilwara North',
            lgdCode: '501631',
            gramPanchayat: 'Bhilwara Ward 1',
            policeStationPostOffice: 'Bhilwara PS / PO',
          ),
        ],
        'Bhilwara Block': [
          const VillageRecord(
            villageName: 'Bhilwara East',
            lgdCode: '501632',
            gramPanchayat: 'Bhilwara East GP',
            policeStationPostOffice: 'Bhilwara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhilwara South',
            lgdCode: '501633',
            gramPanchayat: 'Bhilwara South GP',
            policeStationPostOffice: 'Bhilwara Rural PS',
          ),
        ],
      },
      'Bikaner': {

        'Bikaner City': [
          const VillageRecord(
            villageName: 'Bikaner Rural',
            lgdCode: '501634',
            gramPanchayat: 'Bikaner GP',
            policeStationPostOffice: 'Bikaner PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bikaner North',
            lgdCode: '501635',
            gramPanchayat: 'Bikaner Ward 1',
            policeStationPostOffice: 'Bikaner PS / PO',
          ),
        ],
        'Bikaner Block': [
          const VillageRecord(
            villageName: 'Bikaner East',
            lgdCode: '501636',
            gramPanchayat: 'Bikaner East GP',
            policeStationPostOffice: 'Bikaner Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bikaner South',
            lgdCode: '501637',
            gramPanchayat: 'Bikaner South GP',
            policeStationPostOffice: 'Bikaner Rural PS',
          ),
        ],
      },
      'Bundi': {

        'Bundi City': [
          const VillageRecord(
            villageName: 'Bundi Rural',
            lgdCode: '501638',
            gramPanchayat: 'Bundi GP',
            policeStationPostOffice: 'Bundi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bundi North',
            lgdCode: '501639',
            gramPanchayat: 'Bundi Ward 1',
            policeStationPostOffice: 'Bundi PS / PO',
          ),
        ],
        'Bundi Block': [
          const VillageRecord(
            villageName: 'Bundi East',
            lgdCode: '501640',
            gramPanchayat: 'Bundi East GP',
            policeStationPostOffice: 'Bundi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bundi South',
            lgdCode: '501641',
            gramPanchayat: 'Bundi South GP',
            policeStationPostOffice: 'Bundi Rural PS',
          ),
        ],
      },
      'Chittorgarh': {

        'Chittorgarh City': [
          const VillageRecord(
            villageName: 'Chittorgarh Rural',
            lgdCode: '501642',
            gramPanchayat: 'Chittorgarh GP',
            policeStationPostOffice: 'Chittorgarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chittorgarh North',
            lgdCode: '501643',
            gramPanchayat: 'Chittorgarh Ward 1',
            policeStationPostOffice: 'Chittorgarh PS / PO',
          ),
        ],
        'Chittorgarh Block': [
          const VillageRecord(
            villageName: 'Chittorgarh East',
            lgdCode: '501644',
            gramPanchayat: 'Chittorgarh East GP',
            policeStationPostOffice: 'Chittorgarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chittorgarh South',
            lgdCode: '501645',
            gramPanchayat: 'Chittorgarh South GP',
            policeStationPostOffice: 'Chittorgarh Rural PS',
          ),
        ],
      },
      'Churu': {

        'Churu City': [
          const VillageRecord(
            villageName: 'Churu Rural',
            lgdCode: '501646',
            gramPanchayat: 'Churu GP',
            policeStationPostOffice: 'Churu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Churu North',
            lgdCode: '501647',
            gramPanchayat: 'Churu Ward 1',
            policeStationPostOffice: 'Churu PS / PO',
          ),
        ],
        'Churu Block': [
          const VillageRecord(
            villageName: 'Churu East',
            lgdCode: '501648',
            gramPanchayat: 'Churu East GP',
            policeStationPostOffice: 'Churu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Churu South',
            lgdCode: '501649',
            gramPanchayat: 'Churu South GP',
            policeStationPostOffice: 'Churu Rural PS',
          ),
        ],
      },
      'Dausa': {

        'Dausa City': [
          const VillageRecord(
            villageName: 'Dausa Rural',
            lgdCode: '501650',
            gramPanchayat: 'Dausa GP',
            policeStationPostOffice: 'Dausa PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dausa North',
            lgdCode: '501651',
            gramPanchayat: 'Dausa Ward 1',
            policeStationPostOffice: 'Dausa PS / PO',
          ),
        ],
        'Dausa Block': [
          const VillageRecord(
            villageName: 'Dausa East',
            lgdCode: '501652',
            gramPanchayat: 'Dausa East GP',
            policeStationPostOffice: 'Dausa Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dausa South',
            lgdCode: '501653',
            gramPanchayat: 'Dausa South GP',
            policeStationPostOffice: 'Dausa Rural PS',
          ),
        ],
      },
      'Deeg': {

        'Deeg City': [
          const VillageRecord(
            villageName: 'Deeg Rural',
            lgdCode: '501654',
            gramPanchayat: 'Deeg GP',
            policeStationPostOffice: 'Deeg PS / PO',
          ),
          const VillageRecord(
            villageName: 'Deeg North',
            lgdCode: '501655',
            gramPanchayat: 'Deeg Ward 1',
            policeStationPostOffice: 'Deeg PS / PO',
          ),
        ],
        'Deeg Block': [
          const VillageRecord(
            villageName: 'Deeg East',
            lgdCode: '501656',
            gramPanchayat: 'Deeg East GP',
            policeStationPostOffice: 'Deeg Rural PS',
          ),
          const VillageRecord(
            villageName: 'Deeg South',
            lgdCode: '501657',
            gramPanchayat: 'Deeg South GP',
            policeStationPostOffice: 'Deeg Rural PS',
          ),
        ],
      },
      'Dholpur': {

        'Dholpur City': [
          const VillageRecord(
            villageName: 'Dholpur Rural',
            lgdCode: '501658',
            gramPanchayat: 'Dholpur GP',
            policeStationPostOffice: 'Dholpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dholpur North',
            lgdCode: '501659',
            gramPanchayat: 'Dholpur Ward 1',
            policeStationPostOffice: 'Dholpur PS / PO',
          ),
        ],
        'Dholpur Block': [
          const VillageRecord(
            villageName: 'Dholpur East',
            lgdCode: '501660',
            gramPanchayat: 'Dholpur East GP',
            policeStationPostOffice: 'Dholpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dholpur South',
            lgdCode: '501661',
            gramPanchayat: 'Dholpur South GP',
            policeStationPostOffice: 'Dholpur Rural PS',
          ),
        ],
      },
      'Didwana-Kuchaman': {

        'Didwana-Kuchaman City': [
          const VillageRecord(
            villageName: 'Didwana-Kuchaman Rural',
            lgdCode: '501662',
            gramPanchayat: 'Didwana-Kuchaman GP',
            policeStationPostOffice: 'Didwana-Kuchaman PS / PO',
          ),
          const VillageRecord(
            villageName: 'Didwana-Kuchaman North',
            lgdCode: '501663',
            gramPanchayat: 'Didwana-Kuchaman Ward 1',
            policeStationPostOffice: 'Didwana-Kuchaman PS / PO',
          ),
        ],
        'Didwana-Kuchaman Block': [
          const VillageRecord(
            villageName: 'Didwana-Kuchaman East',
            lgdCode: '501664',
            gramPanchayat: 'Didwana-Kuchaman East GP',
            policeStationPostOffice: 'Didwana-Kuchaman Rural PS',
          ),
          const VillageRecord(
            villageName: 'Didwana-Kuchaman South',
            lgdCode: '501665',
            gramPanchayat: 'Didwana-Kuchaman South GP',
            policeStationPostOffice: 'Didwana-Kuchaman Rural PS',
          ),
        ],
      },
      'Dudu': {

        'Dudu City': [
          const VillageRecord(
            villageName: 'Dudu Rural',
            lgdCode: '501666',
            gramPanchayat: 'Dudu GP',
            policeStationPostOffice: 'Dudu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dudu North',
            lgdCode: '501667',
            gramPanchayat: 'Dudu Ward 1',
            policeStationPostOffice: 'Dudu PS / PO',
          ),
        ],
        'Dudu Block': [
          const VillageRecord(
            villageName: 'Dudu East',
            lgdCode: '501668',
            gramPanchayat: 'Dudu East GP',
            policeStationPostOffice: 'Dudu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dudu South',
            lgdCode: '501669',
            gramPanchayat: 'Dudu South GP',
            policeStationPostOffice: 'Dudu Rural PS',
          ),
        ],
      },
      'Dungarpur': {

        'Dungarpur City': [
          const VillageRecord(
            villageName: 'Dungarpur Rural',
            lgdCode: '501670',
            gramPanchayat: 'Dungarpur GP',
            policeStationPostOffice: 'Dungarpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dungarpur North',
            lgdCode: '501671',
            gramPanchayat: 'Dungarpur Ward 1',
            policeStationPostOffice: 'Dungarpur PS / PO',
          ),
        ],
        'Dungarpur Block': [
          const VillageRecord(
            villageName: 'Dungarpur East',
            lgdCode: '501672',
            gramPanchayat: 'Dungarpur East GP',
            policeStationPostOffice: 'Dungarpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dungarpur South',
            lgdCode: '501673',
            gramPanchayat: 'Dungarpur South GP',
            policeStationPostOffice: 'Dungarpur Rural PS',
          ),
        ],
      },
      'Ganganagar': {

        'Ganganagar City': [
          const VillageRecord(
            villageName: 'Ganganagar Rural',
            lgdCode: '501674',
            gramPanchayat: 'Ganganagar GP',
            policeStationPostOffice: 'Ganganagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ganganagar North',
            lgdCode: '501675',
            gramPanchayat: 'Ganganagar Ward 1',
            policeStationPostOffice: 'Ganganagar PS / PO',
          ),
        ],
        'Ganganagar Block': [
          const VillageRecord(
            villageName: 'Ganganagar East',
            lgdCode: '501676',
            gramPanchayat: 'Ganganagar East GP',
            policeStationPostOffice: 'Ganganagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ganganagar South',
            lgdCode: '501677',
            gramPanchayat: 'Ganganagar South GP',
            policeStationPostOffice: 'Ganganagar Rural PS',
          ),
        ],
      },
      'Gangapurcity': {

        'Gangapurcity City': [
          const VillageRecord(
            villageName: 'Gangapurcity Rural',
            lgdCode: '501678',
            gramPanchayat: 'Gangapurcity GP',
            policeStationPostOffice: 'Gangapurcity PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gangapurcity North',
            lgdCode: '501679',
            gramPanchayat: 'Gangapurcity Ward 1',
            policeStationPostOffice: 'Gangapurcity PS / PO',
          ),
        ],
        'Gangapurcity Block': [
          const VillageRecord(
            villageName: 'Gangapurcity East',
            lgdCode: '501680',
            gramPanchayat: 'Gangapurcity East GP',
            policeStationPostOffice: 'Gangapurcity Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gangapurcity South',
            lgdCode: '501681',
            gramPanchayat: 'Gangapurcity South GP',
            policeStationPostOffice: 'Gangapurcity Rural PS',
          ),
        ],
      },
      'Hanumangarh': {

        'Hanumangarh City': [
          const VillageRecord(
            villageName: 'Hanumangarh Rural',
            lgdCode: '501682',
            gramPanchayat: 'Hanumangarh GP',
            policeStationPostOffice: 'Hanumangarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hanumangarh North',
            lgdCode: '501683',
            gramPanchayat: 'Hanumangarh Ward 1',
            policeStationPostOffice: 'Hanumangarh PS / PO',
          ),
        ],
        'Hanumangarh Block': [
          const VillageRecord(
            villageName: 'Hanumangarh East',
            lgdCode: '501684',
            gramPanchayat: 'Hanumangarh East GP',
            policeStationPostOffice: 'Hanumangarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hanumangarh South',
            lgdCode: '501685',
            gramPanchayat: 'Hanumangarh South GP',
            policeStationPostOffice: 'Hanumangarh Rural PS',
          ),
        ],
      },
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
      'Jaipur Rural': {


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
      'Jaisalmer': {

        'Jaisalmer City': [
          const VillageRecord(
            villageName: 'Jaisalmer Rural',
            lgdCode: '501686',
            gramPanchayat: 'Jaisalmer GP',
            policeStationPostOffice: 'Jaisalmer PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jaisalmer North',
            lgdCode: '501687',
            gramPanchayat: 'Jaisalmer Ward 1',
            policeStationPostOffice: 'Jaisalmer PS / PO',
          ),
        ],
        'Jaisalmer Block': [
          const VillageRecord(
            villageName: 'Jaisalmer East',
            lgdCode: '501688',
            gramPanchayat: 'Jaisalmer East GP',
            policeStationPostOffice: 'Jaisalmer Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jaisalmer South',
            lgdCode: '501689',
            gramPanchayat: 'Jaisalmer South GP',
            policeStationPostOffice: 'Jaisalmer Rural PS',
          ),
        ],
      },
      'Jalore': {

        'Jalore City': [
          const VillageRecord(
            villageName: 'Jalore Rural',
            lgdCode: '501690',
            gramPanchayat: 'Jalore GP',
            policeStationPostOffice: 'Jalore PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jalore North',
            lgdCode: '501691',
            gramPanchayat: 'Jalore Ward 1',
            policeStationPostOffice: 'Jalore PS / PO',
          ),
        ],
        'Jalore Block': [
          const VillageRecord(
            villageName: 'Jalore East',
            lgdCode: '501692',
            gramPanchayat: 'Jalore East GP',
            policeStationPostOffice: 'Jalore Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jalore South',
            lgdCode: '501693',
            gramPanchayat: 'Jalore South GP',
            policeStationPostOffice: 'Jalore Rural PS',
          ),
        ],
      },
      'Jhalawar': {

        'Jhalawar City': [
          const VillageRecord(
            villageName: 'Jhalawar Rural',
            lgdCode: '501694',
            gramPanchayat: 'Jhalawar GP',
            policeStationPostOffice: 'Jhalawar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jhalawar North',
            lgdCode: '501695',
            gramPanchayat: 'Jhalawar Ward 1',
            policeStationPostOffice: 'Jhalawar PS / PO',
          ),
        ],
        'Jhalawar Block': [
          const VillageRecord(
            villageName: 'Jhalawar East',
            lgdCode: '501696',
            gramPanchayat: 'Jhalawar East GP',
            policeStationPostOffice: 'Jhalawar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jhalawar South',
            lgdCode: '501697',
            gramPanchayat: 'Jhalawar South GP',
            policeStationPostOffice: 'Jhalawar Rural PS',
          ),
        ],
      },
      'Jhunjhunu': {

        'Jhunjhunu City': [
          const VillageRecord(
            villageName: 'Jhunjhunu Rural',
            lgdCode: '501698',
            gramPanchayat: 'Jhunjhunu GP',
            policeStationPostOffice: 'Jhunjhunu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jhunjhunu North',
            lgdCode: '501699',
            gramPanchayat: 'Jhunjhunu Ward 1',
            policeStationPostOffice: 'Jhunjhunu PS / PO',
          ),
        ],
        'Jhunjhunu Block': [
          const VillageRecord(
            villageName: 'Jhunjhunu East',
            lgdCode: '501700',
            gramPanchayat: 'Jhunjhunu East GP',
            policeStationPostOffice: 'Jhunjhunu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jhunjhunu South',
            lgdCode: '501701',
            gramPanchayat: 'Jhunjhunu South GP',
            policeStationPostOffice: 'Jhunjhunu Rural PS',
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
      'Jodhpur Rural': {


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
      'Karauli': {

        'Karauli City': [
          const VillageRecord(
            villageName: 'Karauli Rural',
            lgdCode: '501702',
            gramPanchayat: 'Karauli GP',
            policeStationPostOffice: 'Karauli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Karauli North',
            lgdCode: '501703',
            gramPanchayat: 'Karauli Ward 1',
            policeStationPostOffice: 'Karauli PS / PO',
          ),
        ],
        'Karauli Block': [
          const VillageRecord(
            villageName: 'Karauli East',
            lgdCode: '501704',
            gramPanchayat: 'Karauli East GP',
            policeStationPostOffice: 'Karauli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Karauli South',
            lgdCode: '501705',
            gramPanchayat: 'Karauli South GP',
            policeStationPostOffice: 'Karauli Rural PS',
          ),
        ],
      },
      'Kekri': {

        'Kekri City': [
          const VillageRecord(
            villageName: 'Kekri Rural',
            lgdCode: '501706',
            gramPanchayat: 'Kekri GP',
            policeStationPostOffice: 'Kekri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kekri North',
            lgdCode: '501707',
            gramPanchayat: 'Kekri Ward 1',
            policeStationPostOffice: 'Kekri PS / PO',
          ),
        ],
        'Kekri Block': [
          const VillageRecord(
            villageName: 'Kekri East',
            lgdCode: '501708',
            gramPanchayat: 'Kekri East GP',
            policeStationPostOffice: 'Kekri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kekri South',
            lgdCode: '501709',
            gramPanchayat: 'Kekri South GP',
            policeStationPostOffice: 'Kekri Rural PS',
          ),
        ],
      },
      'Khairthal-Tijara': {

        'Khairthal-Tijara City': [
          const VillageRecord(
            villageName: 'Khairthal-Tijara Rural',
            lgdCode: '501710',
            gramPanchayat: 'Khairthal-Tijara GP',
            policeStationPostOffice: 'Khairthal-Tijara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khairthal-Tijara North',
            lgdCode: '501711',
            gramPanchayat: 'Khairthal-Tijara Ward 1',
            policeStationPostOffice: 'Khairthal-Tijara PS / PO',
          ),
        ],
        'Khairthal-Tijara Block': [
          const VillageRecord(
            villageName: 'Khairthal-Tijara East',
            lgdCode: '501712',
            gramPanchayat: 'Khairthal-Tijara East GP',
            policeStationPostOffice: 'Khairthal-Tijara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khairthal-Tijara South',
            lgdCode: '501713',
            gramPanchayat: 'Khairthal-Tijara South GP',
            policeStationPostOffice: 'Khairthal-Tijara Rural PS',
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
      'Kotputli-Behror': {

        'Kotputli-Behror City': [
          const VillageRecord(
            villageName: 'Kotputli-Behror Rural',
            lgdCode: '501714',
            gramPanchayat: 'Kotputli-Behror GP',
            policeStationPostOffice: 'Kotputli-Behror PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kotputli-Behror North',
            lgdCode: '501715',
            gramPanchayat: 'Kotputli-Behror Ward 1',
            policeStationPostOffice: 'Kotputli-Behror PS / PO',
          ),
        ],
        'Kotputli-Behror Block': [
          const VillageRecord(
            villageName: 'Kotputli-Behror East',
            lgdCode: '501716',
            gramPanchayat: 'Kotputli-Behror East GP',
            policeStationPostOffice: 'Kotputli-Behror Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kotputli-Behror South',
            lgdCode: '501717',
            gramPanchayat: 'Kotputli-Behror South GP',
            policeStationPostOffice: 'Kotputli-Behror Rural PS',
          ),
        ],
      },
      'Nagaur': {

        'Nagaur City': [
          const VillageRecord(
            villageName: 'Nagaur Rural',
            lgdCode: '501718',
            gramPanchayat: 'Nagaur GP',
            policeStationPostOffice: 'Nagaur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nagaur North',
            lgdCode: '501719',
            gramPanchayat: 'Nagaur Ward 1',
            policeStationPostOffice: 'Nagaur PS / PO',
          ),
        ],
        'Nagaur Block': [
          const VillageRecord(
            villageName: 'Nagaur East',
            lgdCode: '501720',
            gramPanchayat: 'Nagaur East GP',
            policeStationPostOffice: 'Nagaur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nagaur South',
            lgdCode: '501721',
            gramPanchayat: 'Nagaur South GP',
            policeStationPostOffice: 'Nagaur Rural PS',
          ),
        ],
      },
      'Neem Ka Thana': {

        'Neem Ka Thana City': [
          const VillageRecord(
            villageName: 'Neem Ka Thana Rural',
            lgdCode: '501722',
            gramPanchayat: 'Neem Ka Thana GP',
            policeStationPostOffice: 'Neem Ka Thana PS / PO',
          ),
          const VillageRecord(
            villageName: 'Neem Ka Thana North',
            lgdCode: '501723',
            gramPanchayat: 'Neem Ka Thana Ward 1',
            policeStationPostOffice: 'Neem Ka Thana PS / PO',
          ),
        ],
        'Neem Ka Thana Block': [
          const VillageRecord(
            villageName: 'Neem Ka Thana East',
            lgdCode: '501724',
            gramPanchayat: 'Neem Ka Thana East GP',
            policeStationPostOffice: 'Neem Ka Thana Rural PS',
          ),
          const VillageRecord(
            villageName: 'Neem Ka Thana South',
            lgdCode: '501725',
            gramPanchayat: 'Neem Ka Thana South GP',
            policeStationPostOffice: 'Neem Ka Thana Rural PS',
          ),
        ],
      },
      'Pali': {

        'Pali City': [
          const VillageRecord(
            villageName: 'Pali Rural',
            lgdCode: '501726',
            gramPanchayat: 'Pali GP',
            policeStationPostOffice: 'Pali PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pali North',
            lgdCode: '501727',
            gramPanchayat: 'Pali Ward 1',
            policeStationPostOffice: 'Pali PS / PO',
          ),
        ],
        'Pali Block': [
          const VillageRecord(
            villageName: 'Pali East',
            lgdCode: '501728',
            gramPanchayat: 'Pali East GP',
            policeStationPostOffice: 'Pali Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pali South',
            lgdCode: '501729',
            gramPanchayat: 'Pali South GP',
            policeStationPostOffice: 'Pali Rural PS',
          ),
        ],
      },
      'Phalodi': {

        'Phalodi City': [
          const VillageRecord(
            villageName: 'Phalodi Rural',
            lgdCode: '501730',
            gramPanchayat: 'Phalodi GP',
            policeStationPostOffice: 'Phalodi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Phalodi North',
            lgdCode: '501731',
            gramPanchayat: 'Phalodi Ward 1',
            policeStationPostOffice: 'Phalodi PS / PO',
          ),
        ],
        'Phalodi Block': [
          const VillageRecord(
            villageName: 'Phalodi East',
            lgdCode: '501732',
            gramPanchayat: 'Phalodi East GP',
            policeStationPostOffice: 'Phalodi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Phalodi South',
            lgdCode: '501733',
            gramPanchayat: 'Phalodi South GP',
            policeStationPostOffice: 'Phalodi Rural PS',
          ),
        ],
      },
      'Pratapgarh': {

        'Pratapgarh City': [
          const VillageRecord(
            villageName: 'Pratapgarh Rural',
            lgdCode: '501734',
            gramPanchayat: 'Pratapgarh GP',
            policeStationPostOffice: 'Pratapgarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pratapgarh North',
            lgdCode: '501735',
            gramPanchayat: 'Pratapgarh Ward 1',
            policeStationPostOffice: 'Pratapgarh PS / PO',
          ),
        ],
        'Pratapgarh Block': [
          const VillageRecord(
            villageName: 'Pratapgarh East',
            lgdCode: '501736',
            gramPanchayat: 'Pratapgarh East GP',
            policeStationPostOffice: 'Pratapgarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pratapgarh South',
            lgdCode: '501737',
            gramPanchayat: 'Pratapgarh South GP',
            policeStationPostOffice: 'Pratapgarh Rural PS',
          ),
        ],
      },
      'Rajsamand': {

        'Rajsamand City': [
          const VillageRecord(
            villageName: 'Rajsamand Rural',
            lgdCode: '501738',
            gramPanchayat: 'Rajsamand GP',
            policeStationPostOffice: 'Rajsamand PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rajsamand North',
            lgdCode: '501739',
            gramPanchayat: 'Rajsamand Ward 1',
            policeStationPostOffice: 'Rajsamand PS / PO',
          ),
        ],
        'Rajsamand Block': [
          const VillageRecord(
            villageName: 'Rajsamand East',
            lgdCode: '501740',
            gramPanchayat: 'Rajsamand East GP',
            policeStationPostOffice: 'Rajsamand Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rajsamand South',
            lgdCode: '501741',
            gramPanchayat: 'Rajsamand South GP',
            policeStationPostOffice: 'Rajsamand Rural PS',
          ),
        ],
      },
      'Salumbar': {

        'Salumbar City': [
          const VillageRecord(
            villageName: 'Salumbar Rural',
            lgdCode: '501742',
            gramPanchayat: 'Salumbar GP',
            policeStationPostOffice: 'Salumbar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Salumbar North',
            lgdCode: '501743',
            gramPanchayat: 'Salumbar Ward 1',
            policeStationPostOffice: 'Salumbar PS / PO',
          ),
        ],
        'Salumbar Block': [
          const VillageRecord(
            villageName: 'Salumbar East',
            lgdCode: '501744',
            gramPanchayat: 'Salumbar East GP',
            policeStationPostOffice: 'Salumbar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Salumbar South',
            lgdCode: '501745',
            gramPanchayat: 'Salumbar South GP',
            policeStationPostOffice: 'Salumbar Rural PS',
          ),
        ],
      },
      'Sanchore': {

        'Sanchore City': [
          const VillageRecord(
            villageName: 'Sanchore Rural',
            lgdCode: '501746',
            gramPanchayat: 'Sanchore GP',
            policeStationPostOffice: 'Sanchore PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sanchore North',
            lgdCode: '501747',
            gramPanchayat: 'Sanchore Ward 1',
            policeStationPostOffice: 'Sanchore PS / PO',
          ),
        ],
        'Sanchore Block': [
          const VillageRecord(
            villageName: 'Sanchore East',
            lgdCode: '501748',
            gramPanchayat: 'Sanchore East GP',
            policeStationPostOffice: 'Sanchore Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sanchore South',
            lgdCode: '501749',
            gramPanchayat: 'Sanchore South GP',
            policeStationPostOffice: 'Sanchore Rural PS',
          ),
        ],
      },
      'Sawai Madhopur': {

        'Sawai Madhopur City': [
          const VillageRecord(
            villageName: 'Sawai Madhopur Rural',
            lgdCode: '501750',
            gramPanchayat: 'Sawai Madhopur GP',
            policeStationPostOffice: 'Sawai Madhopur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sawai Madhopur North',
            lgdCode: '501751',
            gramPanchayat: 'Sawai Madhopur Ward 1',
            policeStationPostOffice: 'Sawai Madhopur PS / PO',
          ),
        ],
        'Sawai Madhopur Block': [
          const VillageRecord(
            villageName: 'Sawai Madhopur East',
            lgdCode: '501752',
            gramPanchayat: 'Sawai Madhopur East GP',
            policeStationPostOffice: 'Sawai Madhopur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sawai Madhopur South',
            lgdCode: '501753',
            gramPanchayat: 'Sawai Madhopur South GP',
            policeStationPostOffice: 'Sawai Madhopur Rural PS',
          ),
        ],
      },
      'Shahpura': {

        'Shahpura City': [
          const VillageRecord(
            villageName: 'Shahpura Rural',
            lgdCode: '501754',
            gramPanchayat: 'Shahpura GP',
            policeStationPostOffice: 'Shahpura PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shahpura North',
            lgdCode: '501755',
            gramPanchayat: 'Shahpura Ward 1',
            policeStationPostOffice: 'Shahpura PS / PO',
          ),
        ],
        'Shahpura Block': [
          const VillageRecord(
            villageName: 'Shahpura East',
            lgdCode: '501756',
            gramPanchayat: 'Shahpura East GP',
            policeStationPostOffice: 'Shahpura Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shahpura South',
            lgdCode: '501757',
            gramPanchayat: 'Shahpura South GP',
            policeStationPostOffice: 'Shahpura Rural PS',
          ),
        ],
      },
      'Sikar': {

        'Sikar City': [
          const VillageRecord(
            villageName: 'Sikar Rural',
            lgdCode: '501758',
            gramPanchayat: 'Sikar GP',
            policeStationPostOffice: 'Sikar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sikar North',
            lgdCode: '501759',
            gramPanchayat: 'Sikar Ward 1',
            policeStationPostOffice: 'Sikar PS / PO',
          ),
        ],
        'Sikar Block': [
          const VillageRecord(
            villageName: 'Sikar East',
            lgdCode: '501760',
            gramPanchayat: 'Sikar East GP',
            policeStationPostOffice: 'Sikar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sikar South',
            lgdCode: '501761',
            gramPanchayat: 'Sikar South GP',
            policeStationPostOffice: 'Sikar Rural PS',
          ),
        ],
      },
      'Sirohi': {

        'Sirohi City': [
          const VillageRecord(
            villageName: 'Sirohi Rural',
            lgdCode: '501762',
            gramPanchayat: 'Sirohi GP',
            policeStationPostOffice: 'Sirohi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sirohi North',
            lgdCode: '501763',
            gramPanchayat: 'Sirohi Ward 1',
            policeStationPostOffice: 'Sirohi PS / PO',
          ),
        ],
        'Sirohi Block': [
          const VillageRecord(
            villageName: 'Sirohi East',
            lgdCode: '501764',
            gramPanchayat: 'Sirohi East GP',
            policeStationPostOffice: 'Sirohi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sirohi South',
            lgdCode: '501765',
            gramPanchayat: 'Sirohi South GP',
            policeStationPostOffice: 'Sirohi Rural PS',
          ),
        ],
      },
      'Tonk': {

        'Tonk City': [
          const VillageRecord(
            villageName: 'Tonk Rural',
            lgdCode: '501766',
            gramPanchayat: 'Tonk GP',
            policeStationPostOffice: 'Tonk PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tonk North',
            lgdCode: '501767',
            gramPanchayat: 'Tonk Ward 1',
            policeStationPostOffice: 'Tonk PS / PO',
          ),
        ],
        'Tonk Block': [
          const VillageRecord(
            villageName: 'Tonk East',
            lgdCode: '501768',
            gramPanchayat: 'Tonk East GP',
            policeStationPostOffice: 'Tonk Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tonk South',
            lgdCode: '501769',
            gramPanchayat: 'Tonk South GP',
            policeStationPostOffice: 'Tonk Rural PS',
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
      'Mangan': {

        'Mangan City': [
          const VillageRecord(
            villageName: 'Mangan Rural',
            lgdCode: '501770',
            gramPanchayat: 'Mangan GP',
            policeStationPostOffice: 'Mangan PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mangan North',
            lgdCode: '501771',
            gramPanchayat: 'Mangan Ward 1',
            policeStationPostOffice: 'Mangan PS / PO',
          ),
        ],
        'Mangan Block': [
          const VillageRecord(
            villageName: 'Mangan East',
            lgdCode: '501772',
            gramPanchayat: 'Mangan East GP',
            policeStationPostOffice: 'Mangan Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mangan South',
            lgdCode: '501773',
            gramPanchayat: 'Mangan South GP',
            policeStationPostOffice: 'Mangan Rural PS',
          ),
        ],
      },
      'Pakyong': {

        'Pakyong City': [
          const VillageRecord(
            villageName: 'Pakyong Rural',
            lgdCode: '501774',
            gramPanchayat: 'Pakyong GP',
            policeStationPostOffice: 'Pakyong PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pakyong North',
            lgdCode: '501775',
            gramPanchayat: 'Pakyong Ward 1',
            policeStationPostOffice: 'Pakyong PS / PO',
          ),
        ],
        'Pakyong Block': [
          const VillageRecord(
            villageName: 'Pakyong East',
            lgdCode: '501776',
            gramPanchayat: 'Pakyong East GP',
            policeStationPostOffice: 'Pakyong Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pakyong South',
            lgdCode: '501777',
            gramPanchayat: 'Pakyong South GP',
            policeStationPostOffice: 'Pakyong Rural PS',
          ),
        ],
      },
      'Soreng': {

        'Soreng City': [
          const VillageRecord(
            villageName: 'Soreng Rural',
            lgdCode: '501778',
            gramPanchayat: 'Soreng GP',
            policeStationPostOffice: 'Soreng PS / PO',
          ),
          const VillageRecord(
            villageName: 'Soreng North',
            lgdCode: '501779',
            gramPanchayat: 'Soreng Ward 1',
            policeStationPostOffice: 'Soreng PS / PO',
          ),
        ],
        'Soreng Block': [
          const VillageRecord(
            villageName: 'Soreng East',
            lgdCode: '501780',
            gramPanchayat: 'Soreng East GP',
            policeStationPostOffice: 'Soreng Rural PS',
          ),
          const VillageRecord(
            villageName: 'Soreng South',
            lgdCode: '501781',
            gramPanchayat: 'Soreng South GP',
            policeStationPostOffice: 'Soreng Rural PS',
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
      'Gyalshing': {

        'Gyalshing City': [
          const VillageRecord(
            villageName: 'Gyalshing Rural',
            lgdCode: '501782',
            gramPanchayat: 'Gyalshing GP',
            policeStationPostOffice: 'Gyalshing PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gyalshing North',
            lgdCode: '501783',
            gramPanchayat: 'Gyalshing Ward 1',
            policeStationPostOffice: 'Gyalshing PS / PO',
          ),
        ],
        'Gyalshing Block': [
          const VillageRecord(
            villageName: 'Gyalshing East',
            lgdCode: '501784',
            gramPanchayat: 'Gyalshing East GP',
            policeStationPostOffice: 'Gyalshing Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gyalshing South',
            lgdCode: '501785',
            gramPanchayat: 'Gyalshing South GP',
            policeStationPostOffice: 'Gyalshing Rural PS',
          ),
        ],
      },
    },
    'Tamil Nadu': {
      'Ariyalur': {

        'Ariyalur City': [
          const VillageRecord(
            villageName: 'Ariyalur Rural',
            lgdCode: '501786',
            gramPanchayat: 'Ariyalur GP',
            policeStationPostOffice: 'Ariyalur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ariyalur North',
            lgdCode: '501787',
            gramPanchayat: 'Ariyalur Ward 1',
            policeStationPostOffice: 'Ariyalur PS / PO',
          ),
        ],
        'Ariyalur Block': [
          const VillageRecord(
            villageName: 'Ariyalur East',
            lgdCode: '501788',
            gramPanchayat: 'Ariyalur East GP',
            policeStationPostOffice: 'Ariyalur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ariyalur South',
            lgdCode: '501789',
            gramPanchayat: 'Ariyalur South GP',
            policeStationPostOffice: 'Ariyalur Rural PS',
          ),
        ],
      },
      'Chengalpattu': {

        'Chengalpattu City': [
          const VillageRecord(
            villageName: 'Chengalpattu Rural',
            lgdCode: '501790',
            gramPanchayat: 'Chengalpattu GP',
            policeStationPostOffice: 'Chengalpattu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chengalpattu North',
            lgdCode: '501791',
            gramPanchayat: 'Chengalpattu Ward 1',
            policeStationPostOffice: 'Chengalpattu PS / PO',
          ),
        ],
        'Chengalpattu Block': [
          const VillageRecord(
            villageName: 'Chengalpattu East',
            lgdCode: '501792',
            gramPanchayat: 'Chengalpattu East GP',
            policeStationPostOffice: 'Chengalpattu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chengalpattu South',
            lgdCode: '501793',
            gramPanchayat: 'Chengalpattu South GP',
            policeStationPostOffice: 'Chengalpattu Rural PS',
          ),
        ],
      },
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
      'Cuddalore': {

        'Cuddalore City': [
          const VillageRecord(
            villageName: 'Cuddalore Rural',
            lgdCode: '501794',
            gramPanchayat: 'Cuddalore GP',
            policeStationPostOffice: 'Cuddalore PS / PO',
          ),
          const VillageRecord(
            villageName: 'Cuddalore North',
            lgdCode: '501795',
            gramPanchayat: 'Cuddalore Ward 1',
            policeStationPostOffice: 'Cuddalore PS / PO',
          ),
        ],
        'Cuddalore Block': [
          const VillageRecord(
            villageName: 'Cuddalore East',
            lgdCode: '501796',
            gramPanchayat: 'Cuddalore East GP',
            policeStationPostOffice: 'Cuddalore Rural PS',
          ),
          const VillageRecord(
            villageName: 'Cuddalore South',
            lgdCode: '501797',
            gramPanchayat: 'Cuddalore South GP',
            policeStationPostOffice: 'Cuddalore Rural PS',
          ),
        ],
      },
      'Dharmapuri': {

        'Dharmapuri City': [
          const VillageRecord(
            villageName: 'Dharmapuri Rural',
            lgdCode: '501798',
            gramPanchayat: 'Dharmapuri GP',
            policeStationPostOffice: 'Dharmapuri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dharmapuri North',
            lgdCode: '501799',
            gramPanchayat: 'Dharmapuri Ward 1',
            policeStationPostOffice: 'Dharmapuri PS / PO',
          ),
        ],
        'Dharmapuri Block': [
          const VillageRecord(
            villageName: 'Dharmapuri East',
            lgdCode: '501800',
            gramPanchayat: 'Dharmapuri East GP',
            policeStationPostOffice: 'Dharmapuri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dharmapuri South',
            lgdCode: '501801',
            gramPanchayat: 'Dharmapuri South GP',
            policeStationPostOffice: 'Dharmapuri Rural PS',
          ),
        ],
      },
      'Dindigul': {

        'Dindigul City': [
          const VillageRecord(
            villageName: 'Dindigul Rural',
            lgdCode: '501802',
            gramPanchayat: 'Dindigul GP',
            policeStationPostOffice: 'Dindigul PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dindigul North',
            lgdCode: '501803',
            gramPanchayat: 'Dindigul Ward 1',
            policeStationPostOffice: 'Dindigul PS / PO',
          ),
        ],
        'Dindigul Block': [
          const VillageRecord(
            villageName: 'Dindigul East',
            lgdCode: '501804',
            gramPanchayat: 'Dindigul East GP',
            policeStationPostOffice: 'Dindigul Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dindigul South',
            lgdCode: '501805',
            gramPanchayat: 'Dindigul South GP',
            policeStationPostOffice: 'Dindigul Rural PS',
          ),
        ],
      },
      'Erode': {

        'Erode City': [
          const VillageRecord(
            villageName: 'Erode Rural',
            lgdCode: '501806',
            gramPanchayat: 'Erode GP',
            policeStationPostOffice: 'Erode PS / PO',
          ),
          const VillageRecord(
            villageName: 'Erode North',
            lgdCode: '501807',
            gramPanchayat: 'Erode Ward 1',
            policeStationPostOffice: 'Erode PS / PO',
          ),
        ],
        'Erode Block': [
          const VillageRecord(
            villageName: 'Erode East',
            lgdCode: '501808',
            gramPanchayat: 'Erode East GP',
            policeStationPostOffice: 'Erode Rural PS',
          ),
          const VillageRecord(
            villageName: 'Erode South',
            lgdCode: '501809',
            gramPanchayat: 'Erode South GP',
            policeStationPostOffice: 'Erode Rural PS',
          ),
        ],
      },
      'Kallakurichi': {

        'Kallakurichi City': [
          const VillageRecord(
            villageName: 'Kallakurichi Rural',
            lgdCode: '501810',
            gramPanchayat: 'Kallakurichi GP',
            policeStationPostOffice: 'Kallakurichi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kallakurichi North',
            lgdCode: '501811',
            gramPanchayat: 'Kallakurichi Ward 1',
            policeStationPostOffice: 'Kallakurichi PS / PO',
          ),
        ],
        'Kallakurichi Block': [
          const VillageRecord(
            villageName: 'Kallakurichi East',
            lgdCode: '501812',
            gramPanchayat: 'Kallakurichi East GP',
            policeStationPostOffice: 'Kallakurichi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kallakurichi South',
            lgdCode: '501813',
            gramPanchayat: 'Kallakurichi South GP',
            policeStationPostOffice: 'Kallakurichi Rural PS',
          ),
        ],
      },
      'Kanchipuram': {

        'Kanchipuram City': [
          const VillageRecord(
            villageName: 'Kanchipuram Rural',
            lgdCode: '501814',
            gramPanchayat: 'Kanchipuram GP',
            policeStationPostOffice: 'Kanchipuram PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kanchipuram North',
            lgdCode: '501815',
            gramPanchayat: 'Kanchipuram Ward 1',
            policeStationPostOffice: 'Kanchipuram PS / PO',
          ),
        ],
        'Kanchipuram Block': [
          const VillageRecord(
            villageName: 'Kanchipuram East',
            lgdCode: '501816',
            gramPanchayat: 'Kanchipuram East GP',
            policeStationPostOffice: 'Kanchipuram Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kanchipuram South',
            lgdCode: '501817',
            gramPanchayat: 'Kanchipuram South GP',
            policeStationPostOffice: 'Kanchipuram Rural PS',
          ),
        ],
      },
      'Kanyakumari': {

        'Kanyakumari City': [
          const VillageRecord(
            villageName: 'Kanyakumari Rural',
            lgdCode: '501818',
            gramPanchayat: 'Kanyakumari GP',
            policeStationPostOffice: 'Kanyakumari PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kanyakumari North',
            lgdCode: '501819',
            gramPanchayat: 'Kanyakumari Ward 1',
            policeStationPostOffice: 'Kanyakumari PS / PO',
          ),
        ],
        'Kanyakumari Block': [
          const VillageRecord(
            villageName: 'Kanyakumari East',
            lgdCode: '501820',
            gramPanchayat: 'Kanyakumari East GP',
            policeStationPostOffice: 'Kanyakumari Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kanyakumari South',
            lgdCode: '501821',
            gramPanchayat: 'Kanyakumari South GP',
            policeStationPostOffice: 'Kanyakumari Rural PS',
          ),
        ],
      },
      'Karur': {

        'Karur City': [
          const VillageRecord(
            villageName: 'Karur Rural',
            lgdCode: '501822',
            gramPanchayat: 'Karur GP',
            policeStationPostOffice: 'Karur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Karur North',
            lgdCode: '501823',
            gramPanchayat: 'Karur Ward 1',
            policeStationPostOffice: 'Karur PS / PO',
          ),
        ],
        'Karur Block': [
          const VillageRecord(
            villageName: 'Karur East',
            lgdCode: '501824',
            gramPanchayat: 'Karur East GP',
            policeStationPostOffice: 'Karur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Karur South',
            lgdCode: '501825',
            gramPanchayat: 'Karur South GP',
            policeStationPostOffice: 'Karur Rural PS',
          ),
        ],
      },
      'Krishnagiri': {

        'Krishnagiri City': [
          const VillageRecord(
            villageName: 'Krishnagiri Rural',
            lgdCode: '501826',
            gramPanchayat: 'Krishnagiri GP',
            policeStationPostOffice: 'Krishnagiri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Krishnagiri North',
            lgdCode: '501827',
            gramPanchayat: 'Krishnagiri Ward 1',
            policeStationPostOffice: 'Krishnagiri PS / PO',
          ),
        ],
        'Krishnagiri Block': [
          const VillageRecord(
            villageName: 'Krishnagiri East',
            lgdCode: '501828',
            gramPanchayat: 'Krishnagiri East GP',
            policeStationPostOffice: 'Krishnagiri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Krishnagiri South',
            lgdCode: '501829',
            gramPanchayat: 'Krishnagiri South GP',
            policeStationPostOffice: 'Krishnagiri Rural PS',
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
      'Mayiladuthurai': {

        'Mayiladuthurai City': [
          const VillageRecord(
            villageName: 'Mayiladuthurai Rural',
            lgdCode: '501830',
            gramPanchayat: 'Mayiladuthurai GP',
            policeStationPostOffice: 'Mayiladuthurai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mayiladuthurai North',
            lgdCode: '501831',
            gramPanchayat: 'Mayiladuthurai Ward 1',
            policeStationPostOffice: 'Mayiladuthurai PS / PO',
          ),
        ],
        'Mayiladuthurai Block': [
          const VillageRecord(
            villageName: 'Mayiladuthurai East',
            lgdCode: '501832',
            gramPanchayat: 'Mayiladuthurai East GP',
            policeStationPostOffice: 'Mayiladuthurai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mayiladuthurai South',
            lgdCode: '501833',
            gramPanchayat: 'Mayiladuthurai South GP',
            policeStationPostOffice: 'Mayiladuthurai Rural PS',
          ),
        ],
      },
      'Nagapattinam': {

        'Nagapattinam City': [
          const VillageRecord(
            villageName: 'Nagapattinam Rural',
            lgdCode: '501834',
            gramPanchayat: 'Nagapattinam GP',
            policeStationPostOffice: 'Nagapattinam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nagapattinam North',
            lgdCode: '501835',
            gramPanchayat: 'Nagapattinam Ward 1',
            policeStationPostOffice: 'Nagapattinam PS / PO',
          ),
        ],
        'Nagapattinam Block': [
          const VillageRecord(
            villageName: 'Nagapattinam East',
            lgdCode: '501836',
            gramPanchayat: 'Nagapattinam East GP',
            policeStationPostOffice: 'Nagapattinam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nagapattinam South',
            lgdCode: '501837',
            gramPanchayat: 'Nagapattinam South GP',
            policeStationPostOffice: 'Nagapattinam Rural PS',
          ),
        ],
      },
      'Namakkal': {

        'Namakkal City': [
          const VillageRecord(
            villageName: 'Namakkal Rural',
            lgdCode: '501838',
            gramPanchayat: 'Namakkal GP',
            policeStationPostOffice: 'Namakkal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Namakkal North',
            lgdCode: '501839',
            gramPanchayat: 'Namakkal Ward 1',
            policeStationPostOffice: 'Namakkal PS / PO',
          ),
        ],
        'Namakkal Block': [
          const VillageRecord(
            villageName: 'Namakkal East',
            lgdCode: '501840',
            gramPanchayat: 'Namakkal East GP',
            policeStationPostOffice: 'Namakkal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Namakkal South',
            lgdCode: '501841',
            gramPanchayat: 'Namakkal South GP',
            policeStationPostOffice: 'Namakkal Rural PS',
          ),
        ],
      },
      'Nilgiris': {

        'Nilgiris City': [
          const VillageRecord(
            villageName: 'Nilgiris Rural',
            lgdCode: '501842',
            gramPanchayat: 'Nilgiris GP',
            policeStationPostOffice: 'Nilgiris PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nilgiris North',
            lgdCode: '501843',
            gramPanchayat: 'Nilgiris Ward 1',
            policeStationPostOffice: 'Nilgiris PS / PO',
          ),
        ],
        'Nilgiris Block': [
          const VillageRecord(
            villageName: 'Nilgiris East',
            lgdCode: '501844',
            gramPanchayat: 'Nilgiris East GP',
            policeStationPostOffice: 'Nilgiris Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nilgiris South',
            lgdCode: '501845',
            gramPanchayat: 'Nilgiris South GP',
            policeStationPostOffice: 'Nilgiris Rural PS',
          ),
        ],
      },
      'Perambalur': {

        'Perambalur City': [
          const VillageRecord(
            villageName: 'Perambalur Rural',
            lgdCode: '501846',
            gramPanchayat: 'Perambalur GP',
            policeStationPostOffice: 'Perambalur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Perambalur North',
            lgdCode: '501847',
            gramPanchayat: 'Perambalur Ward 1',
            policeStationPostOffice: 'Perambalur PS / PO',
          ),
        ],
        'Perambalur Block': [
          const VillageRecord(
            villageName: 'Perambalur East',
            lgdCode: '501848',
            gramPanchayat: 'Perambalur East GP',
            policeStationPostOffice: 'Perambalur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Perambalur South',
            lgdCode: '501849',
            gramPanchayat: 'Perambalur South GP',
            policeStationPostOffice: 'Perambalur Rural PS',
          ),
        ],
      },
      'Pudukkottai': {

        'Pudukkottai City': [
          const VillageRecord(
            villageName: 'Pudukkottai Rural',
            lgdCode: '501850',
            gramPanchayat: 'Pudukkottai GP',
            policeStationPostOffice: 'Pudukkottai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pudukkottai North',
            lgdCode: '501851',
            gramPanchayat: 'Pudukkottai Ward 1',
            policeStationPostOffice: 'Pudukkottai PS / PO',
          ),
        ],
        'Pudukkottai Block': [
          const VillageRecord(
            villageName: 'Pudukkottai East',
            lgdCode: '501852',
            gramPanchayat: 'Pudukkottai East GP',
            policeStationPostOffice: 'Pudukkottai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pudukkottai South',
            lgdCode: '501853',
            gramPanchayat: 'Pudukkottai South GP',
            policeStationPostOffice: 'Pudukkottai Rural PS',
          ),
        ],
      },
      'Ramanathapuram': {

        'Ramanathapuram City': [
          const VillageRecord(
            villageName: 'Ramanathapuram Rural',
            lgdCode: '501854',
            gramPanchayat: 'Ramanathapuram GP',
            policeStationPostOffice: 'Ramanathapuram PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ramanathapuram North',
            lgdCode: '501855',
            gramPanchayat: 'Ramanathapuram Ward 1',
            policeStationPostOffice: 'Ramanathapuram PS / PO',
          ),
        ],
        'Ramanathapuram Block': [
          const VillageRecord(
            villageName: 'Ramanathapuram East',
            lgdCode: '501856',
            gramPanchayat: 'Ramanathapuram East GP',
            policeStationPostOffice: 'Ramanathapuram Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ramanathapuram South',
            lgdCode: '501857',
            gramPanchayat: 'Ramanathapuram South GP',
            policeStationPostOffice: 'Ramanathapuram Rural PS',
          ),
        ],
      },
      'Ranipet': {

        'Ranipet City': [
          const VillageRecord(
            villageName: 'Ranipet Rural',
            lgdCode: '501858',
            gramPanchayat: 'Ranipet GP',
            policeStationPostOffice: 'Ranipet PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ranipet North',
            lgdCode: '501859',
            gramPanchayat: 'Ranipet Ward 1',
            policeStationPostOffice: 'Ranipet PS / PO',
          ),
        ],
        'Ranipet Block': [
          const VillageRecord(
            villageName: 'Ranipet East',
            lgdCode: '501860',
            gramPanchayat: 'Ranipet East GP',
            policeStationPostOffice: 'Ranipet Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ranipet South',
            lgdCode: '501861',
            gramPanchayat: 'Ranipet South GP',
            policeStationPostOffice: 'Ranipet Rural PS',
          ),
        ],
      },
      'Salem': {

        'Salem City': [
          const VillageRecord(
            villageName: 'Salem Rural',
            lgdCode: '501862',
            gramPanchayat: 'Salem GP',
            policeStationPostOffice: 'Salem PS / PO',
          ),
          const VillageRecord(
            villageName: 'Salem North',
            lgdCode: '501863',
            gramPanchayat: 'Salem Ward 1',
            policeStationPostOffice: 'Salem PS / PO',
          ),
        ],
        'Salem Block': [
          const VillageRecord(
            villageName: 'Salem East',
            lgdCode: '501864',
            gramPanchayat: 'Salem East GP',
            policeStationPostOffice: 'Salem Rural PS',
          ),
          const VillageRecord(
            villageName: 'Salem South',
            lgdCode: '501865',
            gramPanchayat: 'Salem South GP',
            policeStationPostOffice: 'Salem Rural PS',
          ),
        ],
      },
      'Sivaganga': {

        'Sivaganga City': [
          const VillageRecord(
            villageName: 'Sivaganga Rural',
            lgdCode: '501866',
            gramPanchayat: 'Sivaganga GP',
            policeStationPostOffice: 'Sivaganga PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sivaganga North',
            lgdCode: '501867',
            gramPanchayat: 'Sivaganga Ward 1',
            policeStationPostOffice: 'Sivaganga PS / PO',
          ),
        ],
        'Sivaganga Block': [
          const VillageRecord(
            villageName: 'Sivaganga East',
            lgdCode: '501868',
            gramPanchayat: 'Sivaganga East GP',
            policeStationPostOffice: 'Sivaganga Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sivaganga South',
            lgdCode: '501869',
            gramPanchayat: 'Sivaganga South GP',
            policeStationPostOffice: 'Sivaganga Rural PS',
          ),
        ],
      },
      'Tenkasi': {

        'Tenkasi City': [
          const VillageRecord(
            villageName: 'Tenkasi Rural',
            lgdCode: '501870',
            gramPanchayat: 'Tenkasi GP',
            policeStationPostOffice: 'Tenkasi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tenkasi North',
            lgdCode: '501871',
            gramPanchayat: 'Tenkasi Ward 1',
            policeStationPostOffice: 'Tenkasi PS / PO',
          ),
        ],
        'Tenkasi Block': [
          const VillageRecord(
            villageName: 'Tenkasi East',
            lgdCode: '501872',
            gramPanchayat: 'Tenkasi East GP',
            policeStationPostOffice: 'Tenkasi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tenkasi South',
            lgdCode: '501873',
            gramPanchayat: 'Tenkasi South GP',
            policeStationPostOffice: 'Tenkasi Rural PS',
          ),
        ],
      },
      'Thanjavur': {

        'Thanjavur City': [
          const VillageRecord(
            villageName: 'Thanjavur Rural',
            lgdCode: '501874',
            gramPanchayat: 'Thanjavur GP',
            policeStationPostOffice: 'Thanjavur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Thanjavur North',
            lgdCode: '501875',
            gramPanchayat: 'Thanjavur Ward 1',
            policeStationPostOffice: 'Thanjavur PS / PO',
          ),
        ],
        'Thanjavur Block': [
          const VillageRecord(
            villageName: 'Thanjavur East',
            lgdCode: '501876',
            gramPanchayat: 'Thanjavur East GP',
            policeStationPostOffice: 'Thanjavur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Thanjavur South',
            lgdCode: '501877',
            gramPanchayat: 'Thanjavur South GP',
            policeStationPostOffice: 'Thanjavur Rural PS',
          ),
        ],
      },
      'Theni': {

        'Theni City': [
          const VillageRecord(
            villageName: 'Theni Rural',
            lgdCode: '501878',
            gramPanchayat: 'Theni GP',
            policeStationPostOffice: 'Theni PS / PO',
          ),
          const VillageRecord(
            villageName: 'Theni North',
            lgdCode: '501879',
            gramPanchayat: 'Theni Ward 1',
            policeStationPostOffice: 'Theni PS / PO',
          ),
        ],
        'Theni Block': [
          const VillageRecord(
            villageName: 'Theni East',
            lgdCode: '501880',
            gramPanchayat: 'Theni East GP',
            policeStationPostOffice: 'Theni Rural PS',
          ),
          const VillageRecord(
            villageName: 'Theni South',
            lgdCode: '501881',
            gramPanchayat: 'Theni South GP',
            policeStationPostOffice: 'Theni Rural PS',
          ),
        ],
      },
      'Thoothukudi': {

        'Thoothukudi City': [
          const VillageRecord(
            villageName: 'Thoothukudi Rural',
            lgdCode: '501882',
            gramPanchayat: 'Thoothukudi GP',
            policeStationPostOffice: 'Thoothukudi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Thoothukudi North',
            lgdCode: '501883',
            gramPanchayat: 'Thoothukudi Ward 1',
            policeStationPostOffice: 'Thoothukudi PS / PO',
          ),
        ],
        'Thoothukudi Block': [
          const VillageRecord(
            villageName: 'Thoothukudi East',
            lgdCode: '501884',
            gramPanchayat: 'Thoothukudi East GP',
            policeStationPostOffice: 'Thoothukudi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Thoothukudi South',
            lgdCode: '501885',
            gramPanchayat: 'Thoothukudi South GP',
            policeStationPostOffice: 'Thoothukudi Rural PS',
          ),
        ],
      },
      'Tiruchirappalli': {

        'Tiruchirappalli City': [
          const VillageRecord(
            villageName: 'Tiruchirappalli Rural',
            lgdCode: '501886',
            gramPanchayat: 'Tiruchirappalli GP',
            policeStationPostOffice: 'Tiruchirappalli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tiruchirappalli North',
            lgdCode: '501887',
            gramPanchayat: 'Tiruchirappalli Ward 1',
            policeStationPostOffice: 'Tiruchirappalli PS / PO',
          ),
        ],
        'Tiruchirappalli Block': [
          const VillageRecord(
            villageName: 'Tiruchirappalli East',
            lgdCode: '501888',
            gramPanchayat: 'Tiruchirappalli East GP',
            policeStationPostOffice: 'Tiruchirappalli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tiruchirappalli South',
            lgdCode: '501889',
            gramPanchayat: 'Tiruchirappalli South GP',
            policeStationPostOffice: 'Tiruchirappalli Rural PS',
          ),
        ],
      },
      'Tirunelveli': {

        'Tirunelveli City': [
          const VillageRecord(
            villageName: 'Tirunelveli Rural',
            lgdCode: '501890',
            gramPanchayat: 'Tirunelveli GP',
            policeStationPostOffice: 'Tirunelveli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tirunelveli North',
            lgdCode: '501891',
            gramPanchayat: 'Tirunelveli Ward 1',
            policeStationPostOffice: 'Tirunelveli PS / PO',
          ),
        ],
        'Tirunelveli Block': [
          const VillageRecord(
            villageName: 'Tirunelveli East',
            lgdCode: '501892',
            gramPanchayat: 'Tirunelveli East GP',
            policeStationPostOffice: 'Tirunelveli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tirunelveli South',
            lgdCode: '501893',
            gramPanchayat: 'Tirunelveli South GP',
            policeStationPostOffice: 'Tirunelveli Rural PS',
          ),
        ],
      },
      'Tirupathur': {

        'Tirupathur City': [
          const VillageRecord(
            villageName: 'Tirupathur Rural',
            lgdCode: '501894',
            gramPanchayat: 'Tirupathur GP',
            policeStationPostOffice: 'Tirupathur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tirupathur North',
            lgdCode: '501895',
            gramPanchayat: 'Tirupathur Ward 1',
            policeStationPostOffice: 'Tirupathur PS / PO',
          ),
        ],
        'Tirupathur Block': [
          const VillageRecord(
            villageName: 'Tirupathur East',
            lgdCode: '501896',
            gramPanchayat: 'Tirupathur East GP',
            policeStationPostOffice: 'Tirupathur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tirupathur South',
            lgdCode: '501897',
            gramPanchayat: 'Tirupathur South GP',
            policeStationPostOffice: 'Tirupathur Rural PS',
          ),
        ],
      },
      'Tiruppur': {

        'Tiruppur City': [
          const VillageRecord(
            villageName: 'Tiruppur Rural',
            lgdCode: '501898',
            gramPanchayat: 'Tiruppur GP',
            policeStationPostOffice: 'Tiruppur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tiruppur North',
            lgdCode: '501899',
            gramPanchayat: 'Tiruppur Ward 1',
            policeStationPostOffice: 'Tiruppur PS / PO',
          ),
        ],
        'Tiruppur Block': [
          const VillageRecord(
            villageName: 'Tiruppur East',
            lgdCode: '501900',
            gramPanchayat: 'Tiruppur East GP',
            policeStationPostOffice: 'Tiruppur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tiruppur South',
            lgdCode: '501901',
            gramPanchayat: 'Tiruppur South GP',
            policeStationPostOffice: 'Tiruppur Rural PS',
          ),
        ],
      },
      'Tiruvallur': {

        'Tiruvallur City': [
          const VillageRecord(
            villageName: 'Tiruvallur Rural',
            lgdCode: '501902',
            gramPanchayat: 'Tiruvallur GP',
            policeStationPostOffice: 'Tiruvallur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tiruvallur North',
            lgdCode: '501903',
            gramPanchayat: 'Tiruvallur Ward 1',
            policeStationPostOffice: 'Tiruvallur PS / PO',
          ),
        ],
        'Tiruvallur Block': [
          const VillageRecord(
            villageName: 'Tiruvallur East',
            lgdCode: '501904',
            gramPanchayat: 'Tiruvallur East GP',
            policeStationPostOffice: 'Tiruvallur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tiruvallur South',
            lgdCode: '501905',
            gramPanchayat: 'Tiruvallur South GP',
            policeStationPostOffice: 'Tiruvallur Rural PS',
          ),
        ],
      },
      'Tiruvannamalai': {

        'Tiruvannamalai City': [
          const VillageRecord(
            villageName: 'Tiruvannamalai Rural',
            lgdCode: '501906',
            gramPanchayat: 'Tiruvannamalai GP',
            policeStationPostOffice: 'Tiruvannamalai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tiruvannamalai North',
            lgdCode: '501907',
            gramPanchayat: 'Tiruvannamalai Ward 1',
            policeStationPostOffice: 'Tiruvannamalai PS / PO',
          ),
        ],
        'Tiruvannamalai Block': [
          const VillageRecord(
            villageName: 'Tiruvannamalai East',
            lgdCode: '501908',
            gramPanchayat: 'Tiruvannamalai East GP',
            policeStationPostOffice: 'Tiruvannamalai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tiruvannamalai South',
            lgdCode: '501909',
            gramPanchayat: 'Tiruvannamalai South GP',
            policeStationPostOffice: 'Tiruvannamalai Rural PS',
          ),
        ],
      },
      'Tiruvarur': {

        'Tiruvarur City': [
          const VillageRecord(
            villageName: 'Tiruvarur Rural',
            lgdCode: '501910',
            gramPanchayat: 'Tiruvarur GP',
            policeStationPostOffice: 'Tiruvarur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tiruvarur North',
            lgdCode: '501911',
            gramPanchayat: 'Tiruvarur Ward 1',
            policeStationPostOffice: 'Tiruvarur PS / PO',
          ),
        ],
        'Tiruvarur Block': [
          const VillageRecord(
            villageName: 'Tiruvarur East',
            lgdCode: '501912',
            gramPanchayat: 'Tiruvarur East GP',
            policeStationPostOffice: 'Tiruvarur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tiruvarur South',
            lgdCode: '501913',
            gramPanchayat: 'Tiruvarur South GP',
            policeStationPostOffice: 'Tiruvarur Rural PS',
          ),
        ],
      },
      'Vellore': {

        'Vellore City': [
          const VillageRecord(
            villageName: 'Vellore Rural',
            lgdCode: '501914',
            gramPanchayat: 'Vellore GP',
            policeStationPostOffice: 'Vellore PS / PO',
          ),
          const VillageRecord(
            villageName: 'Vellore North',
            lgdCode: '501915',
            gramPanchayat: 'Vellore Ward 1',
            policeStationPostOffice: 'Vellore PS / PO',
          ),
        ],
        'Vellore Block': [
          const VillageRecord(
            villageName: 'Vellore East',
            lgdCode: '501916',
            gramPanchayat: 'Vellore East GP',
            policeStationPostOffice: 'Vellore Rural PS',
          ),
          const VillageRecord(
            villageName: 'Vellore South',
            lgdCode: '501917',
            gramPanchayat: 'Vellore South GP',
            policeStationPostOffice: 'Vellore Rural PS',
          ),
        ],
      },
      'Viluppuram': {

        'Viluppuram City': [
          const VillageRecord(
            villageName: 'Viluppuram Rural',
            lgdCode: '501918',
            gramPanchayat: 'Viluppuram GP',
            policeStationPostOffice: 'Viluppuram PS / PO',
          ),
          const VillageRecord(
            villageName: 'Viluppuram North',
            lgdCode: '501919',
            gramPanchayat: 'Viluppuram Ward 1',
            policeStationPostOffice: 'Viluppuram PS / PO',
          ),
        ],
        'Viluppuram Block': [
          const VillageRecord(
            villageName: 'Viluppuram East',
            lgdCode: '501920',
            gramPanchayat: 'Viluppuram East GP',
            policeStationPostOffice: 'Viluppuram Rural PS',
          ),
          const VillageRecord(
            villageName: 'Viluppuram South',
            lgdCode: '501921',
            gramPanchayat: 'Viluppuram South GP',
            policeStationPostOffice: 'Viluppuram Rural PS',
          ),
        ],
      },
      'Virudhunagar': {

        'Virudhunagar City': [
          const VillageRecord(
            villageName: 'Virudhunagar Rural',
            lgdCode: '501922',
            gramPanchayat: 'Virudhunagar GP',
            policeStationPostOffice: 'Virudhunagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Virudhunagar North',
            lgdCode: '501923',
            gramPanchayat: 'Virudhunagar Ward 1',
            policeStationPostOffice: 'Virudhunagar PS / PO',
          ),
        ],
        'Virudhunagar Block': [
          const VillageRecord(
            villageName: 'Virudhunagar East',
            lgdCode: '501924',
            gramPanchayat: 'Virudhunagar East GP',
            policeStationPostOffice: 'Virudhunagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Virudhunagar South',
            lgdCode: '501925',
            gramPanchayat: 'Virudhunagar South GP',
            policeStationPostOffice: 'Virudhunagar Rural PS',
          ),
        ],
      },
    },
    'Telangana': {
      'Adilabad': {

        'Adilabad City': [
          const VillageRecord(
            villageName: 'Adilabad Rural',
            lgdCode: '501926',
            gramPanchayat: 'Adilabad GP',
            policeStationPostOffice: 'Adilabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Adilabad North',
            lgdCode: '501927',
            gramPanchayat: 'Adilabad Ward 1',
            policeStationPostOffice: 'Adilabad PS / PO',
          ),
        ],
        'Adilabad Block': [
          const VillageRecord(
            villageName: 'Adilabad East',
            lgdCode: '501928',
            gramPanchayat: 'Adilabad East GP',
            policeStationPostOffice: 'Adilabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Adilabad South',
            lgdCode: '501929',
            gramPanchayat: 'Adilabad South GP',
            policeStationPostOffice: 'Adilabad Rural PS',
          ),
        ],
      },
      'Bhadradri Kothagudem': {

        'Bhadradri Kothagudem City': [
          const VillageRecord(
            villageName: 'Bhadradri Kothagudem Rural',
            lgdCode: '501930',
            gramPanchayat: 'Bhadradri Kothagudem GP',
            policeStationPostOffice: 'Bhadradri Kothagudem PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhadradri Kothagudem North',
            lgdCode: '501931',
            gramPanchayat: 'Bhadradri Kothagudem Ward 1',
            policeStationPostOffice: 'Bhadradri Kothagudem PS / PO',
          ),
        ],
        'Bhadradri Kothagudem Block': [
          const VillageRecord(
            villageName: 'Bhadradri Kothagudem East',
            lgdCode: '501932',
            gramPanchayat: 'Bhadradri Kothagudem East GP',
            policeStationPostOffice: 'Bhadradri Kothagudem Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhadradri Kothagudem South',
            lgdCode: '501933',
            gramPanchayat: 'Bhadradri Kothagudem South GP',
            policeStationPostOffice: 'Bhadradri Kothagudem Rural PS',
          ),
        ],
      },
      'Hanamkonda': {

        'Hanamkonda City': [
          const VillageRecord(
            villageName: 'Hanamkonda Rural',
            lgdCode: '501934',
            gramPanchayat: 'Hanamkonda GP',
            policeStationPostOffice: 'Hanamkonda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hanamkonda North',
            lgdCode: '501935',
            gramPanchayat: 'Hanamkonda Ward 1',
            policeStationPostOffice: 'Hanamkonda PS / PO',
          ),
        ],
        'Hanamkonda Block': [
          const VillageRecord(
            villageName: 'Hanamkonda East',
            lgdCode: '501936',
            gramPanchayat: 'Hanamkonda East GP',
            policeStationPostOffice: 'Hanamkonda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hanamkonda South',
            lgdCode: '501937',
            gramPanchayat: 'Hanamkonda South GP',
            policeStationPostOffice: 'Hanamkonda Rural PS',
          ),
        ],
      },
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
      'Jagtial': {

        'Jagtial City': [
          const VillageRecord(
            villageName: 'Jagtial Rural',
            lgdCode: '501938',
            gramPanchayat: 'Jagtial GP',
            policeStationPostOffice: 'Jagtial PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jagtial North',
            lgdCode: '501939',
            gramPanchayat: 'Jagtial Ward 1',
            policeStationPostOffice: 'Jagtial PS / PO',
          ),
        ],
        'Jagtial Block': [
          const VillageRecord(
            villageName: 'Jagtial East',
            lgdCode: '501940',
            gramPanchayat: 'Jagtial East GP',
            policeStationPostOffice: 'Jagtial Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jagtial South',
            lgdCode: '501941',
            gramPanchayat: 'Jagtial South GP',
            policeStationPostOffice: 'Jagtial Rural PS',
          ),
        ],
      },
      'Jangaon': {

        'Jangaon City': [
          const VillageRecord(
            villageName: 'Jangaon Rural',
            lgdCode: '501942',
            gramPanchayat: 'Jangaon GP',
            policeStationPostOffice: 'Jangaon PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jangaon North',
            lgdCode: '501943',
            gramPanchayat: 'Jangaon Ward 1',
            policeStationPostOffice: 'Jangaon PS / PO',
          ),
        ],
        'Jangaon Block': [
          const VillageRecord(
            villageName: 'Jangaon East',
            lgdCode: '501944',
            gramPanchayat: 'Jangaon East GP',
            policeStationPostOffice: 'Jangaon Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jangaon South',
            lgdCode: '501945',
            gramPanchayat: 'Jangaon South GP',
            policeStationPostOffice: 'Jangaon Rural PS',
          ),
        ],
      },
      'Jayashankar Bhupalpally': {

        'Jayashankar Bhupalpally City': [
          const VillageRecord(
            villageName: 'Jayashankar Bhupalpally Rural',
            lgdCode: '501946',
            gramPanchayat: 'Jayashankar Bhupalpally GP',
            policeStationPostOffice: 'Jayashankar Bhupalpally PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jayashankar Bhupalpally North',
            lgdCode: '501947',
            gramPanchayat: 'Jayashankar Bhupalpally Ward 1',
            policeStationPostOffice: 'Jayashankar Bhupalpally PS / PO',
          ),
        ],
        'Jayashankar Bhupalpally Block': [
          const VillageRecord(
            villageName: 'Jayashankar Bhupalpally East',
            lgdCode: '501948',
            gramPanchayat: 'Jayashankar Bhupalpally East GP',
            policeStationPostOffice: 'Jayashankar Bhupalpally Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jayashankar Bhupalpally South',
            lgdCode: '501949',
            gramPanchayat: 'Jayashankar Bhupalpally South GP',
            policeStationPostOffice: 'Jayashankar Bhupalpally Rural PS',
          ),
        ],
      },
      'Jogulamba Gadwal': {

        'Jogulamba Gadwal City': [
          const VillageRecord(
            villageName: 'Jogulamba Gadwal Rural',
            lgdCode: '501950',
            gramPanchayat: 'Jogulamba Gadwal GP',
            policeStationPostOffice: 'Jogulamba Gadwal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jogulamba Gadwal North',
            lgdCode: '501951',
            gramPanchayat: 'Jogulamba Gadwal Ward 1',
            policeStationPostOffice: 'Jogulamba Gadwal PS / PO',
          ),
        ],
        'Jogulamba Gadwal Block': [
          const VillageRecord(
            villageName: 'Jogulamba Gadwal East',
            lgdCode: '501952',
            gramPanchayat: 'Jogulamba Gadwal East GP',
            policeStationPostOffice: 'Jogulamba Gadwal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jogulamba Gadwal South',
            lgdCode: '501953',
            gramPanchayat: 'Jogulamba Gadwal South GP',
            policeStationPostOffice: 'Jogulamba Gadwal Rural PS',
          ),
        ],
      },
      'Kamareddy': {

        'Kamareddy City': [
          const VillageRecord(
            villageName: 'Kamareddy Rural',
            lgdCode: '501954',
            gramPanchayat: 'Kamareddy GP',
            policeStationPostOffice: 'Kamareddy PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kamareddy North',
            lgdCode: '501955',
            gramPanchayat: 'Kamareddy Ward 1',
            policeStationPostOffice: 'Kamareddy PS / PO',
          ),
        ],
        'Kamareddy Block': [
          const VillageRecord(
            villageName: 'Kamareddy East',
            lgdCode: '501956',
            gramPanchayat: 'Kamareddy East GP',
            policeStationPostOffice: 'Kamareddy Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kamareddy South',
            lgdCode: '501957',
            gramPanchayat: 'Kamareddy South GP',
            policeStationPostOffice: 'Kamareddy Rural PS',
          ),
        ],
      },
      'Karimnagar': {

        'Karimnagar City': [
          const VillageRecord(
            villageName: 'Karimnagar Rural',
            lgdCode: '501958',
            gramPanchayat: 'Karimnagar GP',
            policeStationPostOffice: 'Karimnagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Karimnagar North',
            lgdCode: '501959',
            gramPanchayat: 'Karimnagar Ward 1',
            policeStationPostOffice: 'Karimnagar PS / PO',
          ),
        ],
        'Karimnagar Block': [
          const VillageRecord(
            villageName: 'Karimnagar East',
            lgdCode: '501960',
            gramPanchayat: 'Karimnagar East GP',
            policeStationPostOffice: 'Karimnagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Karimnagar South',
            lgdCode: '501961',
            gramPanchayat: 'Karimnagar South GP',
            policeStationPostOffice: 'Karimnagar Rural PS',
          ),
        ],
      },
      'Khammam': {

        'Khammam City': [
          const VillageRecord(
            villageName: 'Khammam Rural',
            lgdCode: '501962',
            gramPanchayat: 'Khammam GP',
            policeStationPostOffice: 'Khammam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khammam North',
            lgdCode: '501963',
            gramPanchayat: 'Khammam Ward 1',
            policeStationPostOffice: 'Khammam PS / PO',
          ),
        ],
        'Khammam Block': [
          const VillageRecord(
            villageName: 'Khammam East',
            lgdCode: '501964',
            gramPanchayat: 'Khammam East GP',
            policeStationPostOffice: 'Khammam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khammam South',
            lgdCode: '501965',
            gramPanchayat: 'Khammam South GP',
            policeStationPostOffice: 'Khammam Rural PS',
          ),
        ],
      },
      'Kumuram Bheem Asifabad': {

        'Kumuram Bheem Asifabad City': [
          const VillageRecord(
            villageName: 'Kumuram Bheem Asifabad Rural',
            lgdCode: '501966',
            gramPanchayat: 'Kumuram Bheem Asifabad GP',
            policeStationPostOffice: 'Kumuram Bheem Asifabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kumuram Bheem Asifabad North',
            lgdCode: '501967',
            gramPanchayat: 'Kumuram Bheem Asifabad Ward 1',
            policeStationPostOffice: 'Kumuram Bheem Asifabad PS / PO',
          ),
        ],
        'Kumuram Bheem Asifabad Block': [
          const VillageRecord(
            villageName: 'Kumuram Bheem Asifabad East',
            lgdCode: '501968',
            gramPanchayat: 'Kumuram Bheem Asifabad East GP',
            policeStationPostOffice: 'Kumuram Bheem Asifabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kumuram Bheem Asifabad South',
            lgdCode: '501969',
            gramPanchayat: 'Kumuram Bheem Asifabad South GP',
            policeStationPostOffice: 'Kumuram Bheem Asifabad Rural PS',
          ),
        ],
      },
      'Mahabubabad': {

        'Mahabubabad City': [
          const VillageRecord(
            villageName: 'Mahabubabad Rural',
            lgdCode: '501970',
            gramPanchayat: 'Mahabubabad GP',
            policeStationPostOffice: 'Mahabubabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mahabubabad North',
            lgdCode: '501971',
            gramPanchayat: 'Mahabubabad Ward 1',
            policeStationPostOffice: 'Mahabubabad PS / PO',
          ),
        ],
        'Mahabubabad Block': [
          const VillageRecord(
            villageName: 'Mahabubabad East',
            lgdCode: '501972',
            gramPanchayat: 'Mahabubabad East GP',
            policeStationPostOffice: 'Mahabubabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mahabubabad South',
            lgdCode: '501973',
            gramPanchayat: 'Mahabubabad South GP',
            policeStationPostOffice: 'Mahabubabad Rural PS',
          ),
        ],
      },
      'Mahabubnagar': {

        'Mahabubnagar City': [
          const VillageRecord(
            villageName: 'Mahabubnagar Rural',
            lgdCode: '501974',
            gramPanchayat: 'Mahabubnagar GP',
            policeStationPostOffice: 'Mahabubnagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mahabubnagar North',
            lgdCode: '501975',
            gramPanchayat: 'Mahabubnagar Ward 1',
            policeStationPostOffice: 'Mahabubnagar PS / PO',
          ),
        ],
        'Mahabubnagar Block': [
          const VillageRecord(
            villageName: 'Mahabubnagar East',
            lgdCode: '501976',
            gramPanchayat: 'Mahabubnagar East GP',
            policeStationPostOffice: 'Mahabubnagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mahabubnagar South',
            lgdCode: '501977',
            gramPanchayat: 'Mahabubnagar South GP',
            policeStationPostOffice: 'Mahabubnagar Rural PS',
          ),
        ],
      },
      'Mancherial': {

        'Mancherial City': [
          const VillageRecord(
            villageName: 'Mancherial Rural',
            lgdCode: '501978',
            gramPanchayat: 'Mancherial GP',
            policeStationPostOffice: 'Mancherial PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mancherial North',
            lgdCode: '501979',
            gramPanchayat: 'Mancherial Ward 1',
            policeStationPostOffice: 'Mancherial PS / PO',
          ),
        ],
        'Mancherial Block': [
          const VillageRecord(
            villageName: 'Mancherial East',
            lgdCode: '501980',
            gramPanchayat: 'Mancherial East GP',
            policeStationPostOffice: 'Mancherial Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mancherial South',
            lgdCode: '501981',
            gramPanchayat: 'Mancherial South GP',
            policeStationPostOffice: 'Mancherial Rural PS',
          ),
        ],
      },
      'Medak': {

        'Medak City': [
          const VillageRecord(
            villageName: 'Medak Rural',
            lgdCode: '501982',
            gramPanchayat: 'Medak GP',
            policeStationPostOffice: 'Medak PS / PO',
          ),
          const VillageRecord(
            villageName: 'Medak North',
            lgdCode: '501983',
            gramPanchayat: 'Medak Ward 1',
            policeStationPostOffice: 'Medak PS / PO',
          ),
        ],
        'Medak Block': [
          const VillageRecord(
            villageName: 'Medak East',
            lgdCode: '501984',
            gramPanchayat: 'Medak East GP',
            policeStationPostOffice: 'Medak Rural PS',
          ),
          const VillageRecord(
            villageName: 'Medak South',
            lgdCode: '501985',
            gramPanchayat: 'Medak South GP',
            policeStationPostOffice: 'Medak Rural PS',
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
      'Mulugu': {

        'Mulugu City': [
          const VillageRecord(
            villageName: 'Mulugu Rural',
            lgdCode: '501986',
            gramPanchayat: 'Mulugu GP',
            policeStationPostOffice: 'Mulugu PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mulugu North',
            lgdCode: '501987',
            gramPanchayat: 'Mulugu Ward 1',
            policeStationPostOffice: 'Mulugu PS / PO',
          ),
        ],
        'Mulugu Block': [
          const VillageRecord(
            villageName: 'Mulugu East',
            lgdCode: '501988',
            gramPanchayat: 'Mulugu East GP',
            policeStationPostOffice: 'Mulugu Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mulugu South',
            lgdCode: '501989',
            gramPanchayat: 'Mulugu South GP',
            policeStationPostOffice: 'Mulugu Rural PS',
          ),
        ],
      },
      'Nagarkurnool': {

        'Nagarkurnool City': [
          const VillageRecord(
            villageName: 'Nagarkurnool Rural',
            lgdCode: '501990',
            gramPanchayat: 'Nagarkurnool GP',
            policeStationPostOffice: 'Nagarkurnool PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nagarkurnool North',
            lgdCode: '501991',
            gramPanchayat: 'Nagarkurnool Ward 1',
            policeStationPostOffice: 'Nagarkurnool PS / PO',
          ),
        ],
        'Nagarkurnool Block': [
          const VillageRecord(
            villageName: 'Nagarkurnool East',
            lgdCode: '501992',
            gramPanchayat: 'Nagarkurnool East GP',
            policeStationPostOffice: 'Nagarkurnool Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nagarkurnool South',
            lgdCode: '501993',
            gramPanchayat: 'Nagarkurnool South GP',
            policeStationPostOffice: 'Nagarkurnool Rural PS',
          ),
        ],
      },
      'Nalgonda': {

        'Nalgonda City': [
          const VillageRecord(
            villageName: 'Nalgonda Rural',
            lgdCode: '501994',
            gramPanchayat: 'Nalgonda GP',
            policeStationPostOffice: 'Nalgonda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nalgonda North',
            lgdCode: '501995',
            gramPanchayat: 'Nalgonda Ward 1',
            policeStationPostOffice: 'Nalgonda PS / PO',
          ),
        ],
        'Nalgonda Block': [
          const VillageRecord(
            villageName: 'Nalgonda East',
            lgdCode: '501996',
            gramPanchayat: 'Nalgonda East GP',
            policeStationPostOffice: 'Nalgonda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nalgonda South',
            lgdCode: '501997',
            gramPanchayat: 'Nalgonda South GP',
            policeStationPostOffice: 'Nalgonda Rural PS',
          ),
        ],
      },
      'Narayanpet': {

        'Narayanpet City': [
          const VillageRecord(
            villageName: 'Narayanpet Rural',
            lgdCode: '501998',
            gramPanchayat: 'Narayanpet GP',
            policeStationPostOffice: 'Narayanpet PS / PO',
          ),
          const VillageRecord(
            villageName: 'Narayanpet North',
            lgdCode: '501999',
            gramPanchayat: 'Narayanpet Ward 1',
            policeStationPostOffice: 'Narayanpet PS / PO',
          ),
        ],
        'Narayanpet Block': [
          const VillageRecord(
            villageName: 'Narayanpet East',
            lgdCode: '502000',
            gramPanchayat: 'Narayanpet East GP',
            policeStationPostOffice: 'Narayanpet Rural PS',
          ),
          const VillageRecord(
            villageName: 'Narayanpet South',
            lgdCode: '502001',
            gramPanchayat: 'Narayanpet South GP',
            policeStationPostOffice: 'Narayanpet Rural PS',
          ),
        ],
      },
      'Nirmal': {

        'Nirmal City': [
          const VillageRecord(
            villageName: 'Nirmal Rural',
            lgdCode: '502002',
            gramPanchayat: 'Nirmal GP',
            policeStationPostOffice: 'Nirmal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nirmal North',
            lgdCode: '502003',
            gramPanchayat: 'Nirmal Ward 1',
            policeStationPostOffice: 'Nirmal PS / PO',
          ),
        ],
        'Nirmal Block': [
          const VillageRecord(
            villageName: 'Nirmal East',
            lgdCode: '502004',
            gramPanchayat: 'Nirmal East GP',
            policeStationPostOffice: 'Nirmal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nirmal South',
            lgdCode: '502005',
            gramPanchayat: 'Nirmal South GP',
            policeStationPostOffice: 'Nirmal Rural PS',
          ),
        ],
      },
      'Nizamabad': {

        'Nizamabad City': [
          const VillageRecord(
            villageName: 'Nizamabad Rural',
            lgdCode: '502006',
            gramPanchayat: 'Nizamabad GP',
            policeStationPostOffice: 'Nizamabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nizamabad North',
            lgdCode: '502007',
            gramPanchayat: 'Nizamabad Ward 1',
            policeStationPostOffice: 'Nizamabad PS / PO',
          ),
        ],
        'Nizamabad Block': [
          const VillageRecord(
            villageName: 'Nizamabad East',
            lgdCode: '502008',
            gramPanchayat: 'Nizamabad East GP',
            policeStationPostOffice: 'Nizamabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nizamabad South',
            lgdCode: '502009',
            gramPanchayat: 'Nizamabad South GP',
            policeStationPostOffice: 'Nizamabad Rural PS',
          ),
        ],
      },
      'Peddapalli': {

        'Peddapalli City': [
          const VillageRecord(
            villageName: 'Peddapalli Rural',
            lgdCode: '502010',
            gramPanchayat: 'Peddapalli GP',
            policeStationPostOffice: 'Peddapalli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Peddapalli North',
            lgdCode: '502011',
            gramPanchayat: 'Peddapalli Ward 1',
            policeStationPostOffice: 'Peddapalli PS / PO',
          ),
        ],
        'Peddapalli Block': [
          const VillageRecord(
            villageName: 'Peddapalli East',
            lgdCode: '502012',
            gramPanchayat: 'Peddapalli East GP',
            policeStationPostOffice: 'Peddapalli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Peddapalli South',
            lgdCode: '502013',
            gramPanchayat: 'Peddapalli South GP',
            policeStationPostOffice: 'Peddapalli Rural PS',
          ),
        ],
      },
      'Rajanna Sircilla': {

        'Rajanna Sircilla City': [
          const VillageRecord(
            villageName: 'Rajanna Sircilla Rural',
            lgdCode: '502014',
            gramPanchayat: 'Rajanna Sircilla GP',
            policeStationPostOffice: 'Rajanna Sircilla PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rajanna Sircilla North',
            lgdCode: '502015',
            gramPanchayat: 'Rajanna Sircilla Ward 1',
            policeStationPostOffice: 'Rajanna Sircilla PS / PO',
          ),
        ],
        'Rajanna Sircilla Block': [
          const VillageRecord(
            villageName: 'Rajanna Sircilla East',
            lgdCode: '502016',
            gramPanchayat: 'Rajanna Sircilla East GP',
            policeStationPostOffice: 'Rajanna Sircilla Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rajanna Sircilla South',
            lgdCode: '502017',
            gramPanchayat: 'Rajanna Sircilla South GP',
            policeStationPostOffice: 'Rajanna Sircilla Rural PS',
          ),
        ],
      },
      'Ranga Reddy': {

        'Ranga Reddy City': [
          const VillageRecord(
            villageName: 'Ranga Reddy Rural',
            lgdCode: '502018',
            gramPanchayat: 'Ranga Reddy GP',
            policeStationPostOffice: 'Ranga Reddy PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ranga Reddy North',
            lgdCode: '502019',
            gramPanchayat: 'Ranga Reddy Ward 1',
            policeStationPostOffice: 'Ranga Reddy PS / PO',
          ),
        ],
        'Ranga Reddy Block': [
          const VillageRecord(
            villageName: 'Ranga Reddy East',
            lgdCode: '502020',
            gramPanchayat: 'Ranga Reddy East GP',
            policeStationPostOffice: 'Ranga Reddy Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ranga Reddy South',
            lgdCode: '502021',
            gramPanchayat: 'Ranga Reddy South GP',
            policeStationPostOffice: 'Ranga Reddy Rural PS',
          ),
        ],
      },
      'Sangareddy': {

        'Sangareddy City': [
          const VillageRecord(
            villageName: 'Sangareddy Rural',
            lgdCode: '502022',
            gramPanchayat: 'Sangareddy GP',
            policeStationPostOffice: 'Sangareddy PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sangareddy North',
            lgdCode: '502023',
            gramPanchayat: 'Sangareddy Ward 1',
            policeStationPostOffice: 'Sangareddy PS / PO',
          ),
        ],
        'Sangareddy Block': [
          const VillageRecord(
            villageName: 'Sangareddy East',
            lgdCode: '502024',
            gramPanchayat: 'Sangareddy East GP',
            policeStationPostOffice: 'Sangareddy Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sangareddy South',
            lgdCode: '502025',
            gramPanchayat: 'Sangareddy South GP',
            policeStationPostOffice: 'Sangareddy Rural PS',
          ),
        ],
      },
      'Siddipet': {

        'Siddipet City': [
          const VillageRecord(
            villageName: 'Siddipet Rural',
            lgdCode: '502026',
            gramPanchayat: 'Siddipet GP',
            policeStationPostOffice: 'Siddipet PS / PO',
          ),
          const VillageRecord(
            villageName: 'Siddipet North',
            lgdCode: '502027',
            gramPanchayat: 'Siddipet Ward 1',
            policeStationPostOffice: 'Siddipet PS / PO',
          ),
        ],
        'Siddipet Block': [
          const VillageRecord(
            villageName: 'Siddipet East',
            lgdCode: '502028',
            gramPanchayat: 'Siddipet East GP',
            policeStationPostOffice: 'Siddipet Rural PS',
          ),
          const VillageRecord(
            villageName: 'Siddipet South',
            lgdCode: '502029',
            gramPanchayat: 'Siddipet South GP',
            policeStationPostOffice: 'Siddipet Rural PS',
          ),
        ],
      },
      'Suryapet': {

        'Suryapet City': [
          const VillageRecord(
            villageName: 'Suryapet Rural',
            lgdCode: '502030',
            gramPanchayat: 'Suryapet GP',
            policeStationPostOffice: 'Suryapet PS / PO',
          ),
          const VillageRecord(
            villageName: 'Suryapet North',
            lgdCode: '502031',
            gramPanchayat: 'Suryapet Ward 1',
            policeStationPostOffice: 'Suryapet PS / PO',
          ),
        ],
        'Suryapet Block': [
          const VillageRecord(
            villageName: 'Suryapet East',
            lgdCode: '502032',
            gramPanchayat: 'Suryapet East GP',
            policeStationPostOffice: 'Suryapet Rural PS',
          ),
          const VillageRecord(
            villageName: 'Suryapet South',
            lgdCode: '502033',
            gramPanchayat: 'Suryapet South GP',
            policeStationPostOffice: 'Suryapet Rural PS',
          ),
        ],
      },
      'Vikarabad': {

        'Vikarabad City': [
          const VillageRecord(
            villageName: 'Vikarabad Rural',
            lgdCode: '502034',
            gramPanchayat: 'Vikarabad GP',
            policeStationPostOffice: 'Vikarabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Vikarabad North',
            lgdCode: '502035',
            gramPanchayat: 'Vikarabad Ward 1',
            policeStationPostOffice: 'Vikarabad PS / PO',
          ),
        ],
        'Vikarabad Block': [
          const VillageRecord(
            villageName: 'Vikarabad East',
            lgdCode: '502036',
            gramPanchayat: 'Vikarabad East GP',
            policeStationPostOffice: 'Vikarabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Vikarabad South',
            lgdCode: '502037',
            gramPanchayat: 'Vikarabad South GP',
            policeStationPostOffice: 'Vikarabad Rural PS',
          ),
        ],
      },
      'Wanaparthy': {

        'Wanaparthy City': [
          const VillageRecord(
            villageName: 'Wanaparthy Rural',
            lgdCode: '502038',
            gramPanchayat: 'Wanaparthy GP',
            policeStationPostOffice: 'Wanaparthy PS / PO',
          ),
          const VillageRecord(
            villageName: 'Wanaparthy North',
            lgdCode: '502039',
            gramPanchayat: 'Wanaparthy Ward 1',
            policeStationPostOffice: 'Wanaparthy PS / PO',
          ),
        ],
        'Wanaparthy Block': [
          const VillageRecord(
            villageName: 'Wanaparthy East',
            lgdCode: '502040',
            gramPanchayat: 'Wanaparthy East GP',
            policeStationPostOffice: 'Wanaparthy Rural PS',
          ),
          const VillageRecord(
            villageName: 'Wanaparthy South',
            lgdCode: '502041',
            gramPanchayat: 'Wanaparthy South GP',
            policeStationPostOffice: 'Wanaparthy Rural PS',
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
      'Yadadri Bhuvanagiri': {

        'Yadadri Bhuvanagiri City': [
          const VillageRecord(
            villageName: 'Yadadri Bhuvanagiri Rural',
            lgdCode: '502042',
            gramPanchayat: 'Yadadri Bhuvanagiri GP',
            policeStationPostOffice: 'Yadadri Bhuvanagiri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Yadadri Bhuvanagiri North',
            lgdCode: '502043',
            gramPanchayat: 'Yadadri Bhuvanagiri Ward 1',
            policeStationPostOffice: 'Yadadri Bhuvanagiri PS / PO',
          ),
        ],
        'Yadadri Bhuvanagiri Block': [
          const VillageRecord(
            villageName: 'Yadadri Bhuvanagiri East',
            lgdCode: '502044',
            gramPanchayat: 'Yadadri Bhuvanagiri East GP',
            policeStationPostOffice: 'Yadadri Bhuvanagiri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Yadadri Bhuvanagiri South',
            lgdCode: '502045',
            gramPanchayat: 'Yadadri Bhuvanagiri South GP',
            policeStationPostOffice: 'Yadadri Bhuvanagiri Rural PS',
          ),
        ],
      },
    },
    'Tripura': {
      'Dhalai': {

        'Dhalai City': [
          const VillageRecord(
            villageName: 'Dhalai Rural',
            lgdCode: '502046',
            gramPanchayat: 'Dhalai GP',
            policeStationPostOffice: 'Dhalai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dhalai North',
            lgdCode: '502047',
            gramPanchayat: 'Dhalai Ward 1',
            policeStationPostOffice: 'Dhalai PS / PO',
          ),
        ],
        'Dhalai Block': [
          const VillageRecord(
            villageName: 'Dhalai East',
            lgdCode: '502048',
            gramPanchayat: 'Dhalai East GP',
            policeStationPostOffice: 'Dhalai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dhalai South',
            lgdCode: '502049',
            gramPanchayat: 'Dhalai South GP',
            policeStationPostOffice: 'Dhalai Rural PS',
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
      'Khowai': {

        'Khowai City': [
          const VillageRecord(
            villageName: 'Khowai Rural',
            lgdCode: '502050',
            gramPanchayat: 'Khowai GP',
            policeStationPostOffice: 'Khowai PS / PO',
          ),
          const VillageRecord(
            villageName: 'Khowai North',
            lgdCode: '502051',
            gramPanchayat: 'Khowai Ward 1',
            policeStationPostOffice: 'Khowai PS / PO',
          ),
        ],
        'Khowai Block': [
          const VillageRecord(
            villageName: 'Khowai East',
            lgdCode: '502052',
            gramPanchayat: 'Khowai East GP',
            policeStationPostOffice: 'Khowai Rural PS',
          ),
          const VillageRecord(
            villageName: 'Khowai South',
            lgdCode: '502053',
            gramPanchayat: 'Khowai South GP',
            policeStationPostOffice: 'Khowai Rural PS',
          ),
        ],
      },
      'North Tripura': {

        'North Tripura City': [
          const VillageRecord(
            villageName: 'North Tripura Rural',
            lgdCode: '502054',
            gramPanchayat: 'North Tripura GP',
            policeStationPostOffice: 'North Tripura PS / PO',
          ),
          const VillageRecord(
            villageName: 'North Tripura North',
            lgdCode: '502055',
            gramPanchayat: 'North Tripura Ward 1',
            policeStationPostOffice: 'North Tripura PS / PO',
          ),
        ],
        'North Tripura Block': [
          const VillageRecord(
            villageName: 'North Tripura East',
            lgdCode: '502056',
            gramPanchayat: 'North Tripura East GP',
            policeStationPostOffice: 'North Tripura Rural PS',
          ),
          const VillageRecord(
            villageName: 'North Tripura South',
            lgdCode: '502057',
            gramPanchayat: 'North Tripura South GP',
            policeStationPostOffice: 'North Tripura Rural PS',
          ),
        ],
      },
      'Sepahijala': {

        'Sepahijala City': [
          const VillageRecord(
            villageName: 'Sepahijala Rural',
            lgdCode: '502058',
            gramPanchayat: 'Sepahijala GP',
            policeStationPostOffice: 'Sepahijala PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sepahijala North',
            lgdCode: '502059',
            gramPanchayat: 'Sepahijala Ward 1',
            policeStationPostOffice: 'Sepahijala PS / PO',
          ),
        ],
        'Sepahijala Block': [
          const VillageRecord(
            villageName: 'Sepahijala East',
            lgdCode: '502060',
            gramPanchayat: 'Sepahijala East GP',
            policeStationPostOffice: 'Sepahijala Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sepahijala South',
            lgdCode: '502061',
            gramPanchayat: 'Sepahijala South GP',
            policeStationPostOffice: 'Sepahijala Rural PS',
          ),
        ],
      },
      'South Tripura': {

        'South Tripura City': [
          const VillageRecord(
            villageName: 'South Tripura Rural',
            lgdCode: '502062',
            gramPanchayat: 'South Tripura GP',
            policeStationPostOffice: 'South Tripura PS / PO',
          ),
          const VillageRecord(
            villageName: 'South Tripura North',
            lgdCode: '502063',
            gramPanchayat: 'South Tripura Ward 1',
            policeStationPostOffice: 'South Tripura PS / PO',
          ),
        ],
        'South Tripura Block': [
          const VillageRecord(
            villageName: 'South Tripura East',
            lgdCode: '502064',
            gramPanchayat: 'South Tripura East GP',
            policeStationPostOffice: 'South Tripura Rural PS',
          ),
          const VillageRecord(
            villageName: 'South Tripura South',
            lgdCode: '502065',
            gramPanchayat: 'South Tripura South GP',
            policeStationPostOffice: 'South Tripura Rural PS',
          ),
        ],
      },
      'Unakoti': {

        'Unakoti City': [
          const VillageRecord(
            villageName: 'Unakoti Rural',
            lgdCode: '502066',
            gramPanchayat: 'Unakoti GP',
            policeStationPostOffice: 'Unakoti PS / PO',
          ),
          const VillageRecord(
            villageName: 'Unakoti North',
            lgdCode: '502067',
            gramPanchayat: 'Unakoti Ward 1',
            policeStationPostOffice: 'Unakoti PS / PO',
          ),
        ],
        'Unakoti Block': [
          const VillageRecord(
            villageName: 'Unakoti East',
            lgdCode: '502068',
            gramPanchayat: 'Unakoti East GP',
            policeStationPostOffice: 'Unakoti Rural PS',
          ),
          const VillageRecord(
            villageName: 'Unakoti South',
            lgdCode: '502069',
            gramPanchayat: 'Unakoti South GP',
            policeStationPostOffice: 'Unakoti Rural PS',
          ),
        ],
      },
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
    },
    'Uttar Pradesh': {
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
      'Aligarh': {

        'Aligarh City': [
          const VillageRecord(
            villageName: 'Aligarh Rural',
            lgdCode: '502070',
            gramPanchayat: 'Aligarh GP',
            policeStationPostOffice: 'Aligarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Aligarh North',
            lgdCode: '502071',
            gramPanchayat: 'Aligarh Ward 1',
            policeStationPostOffice: 'Aligarh PS / PO',
          ),
        ],
        'Aligarh Block': [
          const VillageRecord(
            villageName: 'Aligarh East',
            lgdCode: '502072',
            gramPanchayat: 'Aligarh East GP',
            policeStationPostOffice: 'Aligarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Aligarh South',
            lgdCode: '502073',
            gramPanchayat: 'Aligarh South GP',
            policeStationPostOffice: 'Aligarh Rural PS',
          ),
        ],
      },
      'Ambedkar Nagar': {

        'Ambedkar Nagar City': [
          const VillageRecord(
            villageName: 'Ambedkar Nagar Rural',
            lgdCode: '502074',
            gramPanchayat: 'Ambedkar Nagar GP',
            policeStationPostOffice: 'Ambedkar Nagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ambedkar Nagar North',
            lgdCode: '502075',
            gramPanchayat: 'Ambedkar Nagar Ward 1',
            policeStationPostOffice: 'Ambedkar Nagar PS / PO',
          ),
        ],
        'Ambedkar Nagar Block': [
          const VillageRecord(
            villageName: 'Ambedkar Nagar East',
            lgdCode: '502076',
            gramPanchayat: 'Ambedkar Nagar East GP',
            policeStationPostOffice: 'Ambedkar Nagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ambedkar Nagar South',
            lgdCode: '502077',
            gramPanchayat: 'Ambedkar Nagar South GP',
            policeStationPostOffice: 'Ambedkar Nagar Rural PS',
          ),
        ],
      },
      'Amethi': {

        'Amethi City': [
          const VillageRecord(
            villageName: 'Amethi Rural',
            lgdCode: '502078',
            gramPanchayat: 'Amethi GP',
            policeStationPostOffice: 'Amethi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Amethi North',
            lgdCode: '502079',
            gramPanchayat: 'Amethi Ward 1',
            policeStationPostOffice: 'Amethi PS / PO',
          ),
        ],
        'Amethi Block': [
          const VillageRecord(
            villageName: 'Amethi East',
            lgdCode: '502080',
            gramPanchayat: 'Amethi East GP',
            policeStationPostOffice: 'Amethi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Amethi South',
            lgdCode: '502081',
            gramPanchayat: 'Amethi South GP',
            policeStationPostOffice: 'Amethi Rural PS',
          ),
        ],
      },
      'Amroha': {

        'Amroha City': [
          const VillageRecord(
            villageName: 'Amroha Rural',
            lgdCode: '502082',
            gramPanchayat: 'Amroha GP',
            policeStationPostOffice: 'Amroha PS / PO',
          ),
          const VillageRecord(
            villageName: 'Amroha North',
            lgdCode: '502083',
            gramPanchayat: 'Amroha Ward 1',
            policeStationPostOffice: 'Amroha PS / PO',
          ),
        ],
        'Amroha Block': [
          const VillageRecord(
            villageName: 'Amroha East',
            lgdCode: '502084',
            gramPanchayat: 'Amroha East GP',
            policeStationPostOffice: 'Amroha Rural PS',
          ),
          const VillageRecord(
            villageName: 'Amroha South',
            lgdCode: '502085',
            gramPanchayat: 'Amroha South GP',
            policeStationPostOffice: 'Amroha Rural PS',
          ),
        ],
      },
      'Auraiya': {

        'Auraiya City': [
          const VillageRecord(
            villageName: 'Auraiya Rural',
            lgdCode: '502086',
            gramPanchayat: 'Auraiya GP',
            policeStationPostOffice: 'Auraiya PS / PO',
          ),
          const VillageRecord(
            villageName: 'Auraiya North',
            lgdCode: '502087',
            gramPanchayat: 'Auraiya Ward 1',
            policeStationPostOffice: 'Auraiya PS / PO',
          ),
        ],
        'Auraiya Block': [
          const VillageRecord(
            villageName: 'Auraiya East',
            lgdCode: '502088',
            gramPanchayat: 'Auraiya East GP',
            policeStationPostOffice: 'Auraiya Rural PS',
          ),
          const VillageRecord(
            villageName: 'Auraiya South',
            lgdCode: '502089',
            gramPanchayat: 'Auraiya South GP',
            policeStationPostOffice: 'Auraiya Rural PS',
          ),
        ],
      },
      'Ayodhya': {

        'Ayodhya City': [
          const VillageRecord(
            villageName: 'Ayodhya Rural',
            lgdCode: '502090',
            gramPanchayat: 'Ayodhya GP',
            policeStationPostOffice: 'Ayodhya PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ayodhya North',
            lgdCode: '502091',
            gramPanchayat: 'Ayodhya Ward 1',
            policeStationPostOffice: 'Ayodhya PS / PO',
          ),
        ],
        'Ayodhya Block': [
          const VillageRecord(
            villageName: 'Ayodhya East',
            lgdCode: '502092',
            gramPanchayat: 'Ayodhya East GP',
            policeStationPostOffice: 'Ayodhya Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ayodhya South',
            lgdCode: '502093',
            gramPanchayat: 'Ayodhya South GP',
            policeStationPostOffice: 'Ayodhya Rural PS',
          ),
        ],
      },
      'Azamgarh': {

        'Azamgarh City': [
          const VillageRecord(
            villageName: 'Azamgarh Rural',
            lgdCode: '502094',
            gramPanchayat: 'Azamgarh GP',
            policeStationPostOffice: 'Azamgarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Azamgarh North',
            lgdCode: '502095',
            gramPanchayat: 'Azamgarh Ward 1',
            policeStationPostOffice: 'Azamgarh PS / PO',
          ),
        ],
        'Azamgarh Block': [
          const VillageRecord(
            villageName: 'Azamgarh East',
            lgdCode: '502096',
            gramPanchayat: 'Azamgarh East GP',
            policeStationPostOffice: 'Azamgarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Azamgarh South',
            lgdCode: '502097',
            gramPanchayat: 'Azamgarh South GP',
            policeStationPostOffice: 'Azamgarh Rural PS',
          ),
        ],
      },
      'Baghpat': {

        'Baghpat City': [
          const VillageRecord(
            villageName: 'Baghpat Rural',
            lgdCode: '502098',
            gramPanchayat: 'Baghpat GP',
            policeStationPostOffice: 'Baghpat PS / PO',
          ),
          const VillageRecord(
            villageName: 'Baghpat North',
            lgdCode: '502099',
            gramPanchayat: 'Baghpat Ward 1',
            policeStationPostOffice: 'Baghpat PS / PO',
          ),
        ],
        'Baghpat Block': [
          const VillageRecord(
            villageName: 'Baghpat East',
            lgdCode: '502100',
            gramPanchayat: 'Baghpat East GP',
            policeStationPostOffice: 'Baghpat Rural PS',
          ),
          const VillageRecord(
            villageName: 'Baghpat South',
            lgdCode: '502101',
            gramPanchayat: 'Baghpat South GP',
            policeStationPostOffice: 'Baghpat Rural PS',
          ),
        ],
      },
      'Bahraich': {

        'Bahraich City': [
          const VillageRecord(
            villageName: 'Bahraich Rural',
            lgdCode: '502102',
            gramPanchayat: 'Bahraich GP',
            policeStationPostOffice: 'Bahraich PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bahraich North',
            lgdCode: '502103',
            gramPanchayat: 'Bahraich Ward 1',
            policeStationPostOffice: 'Bahraich PS / PO',
          ),
        ],
        'Bahraich Block': [
          const VillageRecord(
            villageName: 'Bahraich East',
            lgdCode: '502104',
            gramPanchayat: 'Bahraich East GP',
            policeStationPostOffice: 'Bahraich Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bahraich South',
            lgdCode: '502105',
            gramPanchayat: 'Bahraich South GP',
            policeStationPostOffice: 'Bahraich Rural PS',
          ),
        ],
      },
      'Ballia': {

        'Ballia City': [
          const VillageRecord(
            villageName: 'Ballia Rural',
            lgdCode: '502106',
            gramPanchayat: 'Ballia GP',
            policeStationPostOffice: 'Ballia PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ballia North',
            lgdCode: '502107',
            gramPanchayat: 'Ballia Ward 1',
            policeStationPostOffice: 'Ballia PS / PO',
          ),
        ],
        'Ballia Block': [
          const VillageRecord(
            villageName: 'Ballia East',
            lgdCode: '502108',
            gramPanchayat: 'Ballia East GP',
            policeStationPostOffice: 'Ballia Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ballia South',
            lgdCode: '502109',
            gramPanchayat: 'Ballia South GP',
            policeStationPostOffice: 'Ballia Rural PS',
          ),
        ],
      },
      'Balrampur': {

        'Balrampur City': [
          const VillageRecord(
            villageName: 'Balrampur Rural',
            lgdCode: '502110',
            gramPanchayat: 'Balrampur GP',
            policeStationPostOffice: 'Balrampur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balrampur North',
            lgdCode: '502111',
            gramPanchayat: 'Balrampur Ward 1',
            policeStationPostOffice: 'Balrampur PS / PO',
          ),
        ],
        'Balrampur Block': [
          const VillageRecord(
            villageName: 'Balrampur East',
            lgdCode: '502112',
            gramPanchayat: 'Balrampur East GP',
            policeStationPostOffice: 'Balrampur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balrampur South',
            lgdCode: '502113',
            gramPanchayat: 'Balrampur South GP',
            policeStationPostOffice: 'Balrampur Rural PS',
          ),
        ],
      },
      'Banda': {

        'Banda City': [
          const VillageRecord(
            villageName: 'Banda Rural',
            lgdCode: '502114',
            gramPanchayat: 'Banda GP',
            policeStationPostOffice: 'Banda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Banda North',
            lgdCode: '502115',
            gramPanchayat: 'Banda Ward 1',
            policeStationPostOffice: 'Banda PS / PO',
          ),
        ],
        'Banda Block': [
          const VillageRecord(
            villageName: 'Banda East',
            lgdCode: '502116',
            gramPanchayat: 'Banda East GP',
            policeStationPostOffice: 'Banda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Banda South',
            lgdCode: '502117',
            gramPanchayat: 'Banda South GP',
            policeStationPostOffice: 'Banda Rural PS',
          ),
        ],
      },
      'Barabanki': {

        'Barabanki City': [
          const VillageRecord(
            villageName: 'Barabanki Rural',
            lgdCode: '502118',
            gramPanchayat: 'Barabanki GP',
            policeStationPostOffice: 'Barabanki PS / PO',
          ),
          const VillageRecord(
            villageName: 'Barabanki North',
            lgdCode: '502119',
            gramPanchayat: 'Barabanki Ward 1',
            policeStationPostOffice: 'Barabanki PS / PO',
          ),
        ],
        'Barabanki Block': [
          const VillageRecord(
            villageName: 'Barabanki East',
            lgdCode: '502120',
            gramPanchayat: 'Barabanki East GP',
            policeStationPostOffice: 'Barabanki Rural PS',
          ),
          const VillageRecord(
            villageName: 'Barabanki South',
            lgdCode: '502121',
            gramPanchayat: 'Barabanki South GP',
            policeStationPostOffice: 'Barabanki Rural PS',
          ),
        ],
      },
      'Bareilly': {

        'Bareilly City': [
          const VillageRecord(
            villageName: 'Bareilly Rural',
            lgdCode: '502122',
            gramPanchayat: 'Bareilly GP',
            policeStationPostOffice: 'Bareilly PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bareilly North',
            lgdCode: '502123',
            gramPanchayat: 'Bareilly Ward 1',
            policeStationPostOffice: 'Bareilly PS / PO',
          ),
        ],
        'Bareilly Block': [
          const VillageRecord(
            villageName: 'Bareilly East',
            lgdCode: '502124',
            gramPanchayat: 'Bareilly East GP',
            policeStationPostOffice: 'Bareilly Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bareilly South',
            lgdCode: '502125',
            gramPanchayat: 'Bareilly South GP',
            policeStationPostOffice: 'Bareilly Rural PS',
          ),
        ],
      },
      'Basti': {

        'Basti City': [
          const VillageRecord(
            villageName: 'Basti Rural',
            lgdCode: '502126',
            gramPanchayat: 'Basti GP',
            policeStationPostOffice: 'Basti PS / PO',
          ),
          const VillageRecord(
            villageName: 'Basti North',
            lgdCode: '502127',
            gramPanchayat: 'Basti Ward 1',
            policeStationPostOffice: 'Basti PS / PO',
          ),
        ],
        'Basti Block': [
          const VillageRecord(
            villageName: 'Basti East',
            lgdCode: '502128',
            gramPanchayat: 'Basti East GP',
            policeStationPostOffice: 'Basti Rural PS',
          ),
          const VillageRecord(
            villageName: 'Basti South',
            lgdCode: '502129',
            gramPanchayat: 'Basti South GP',
            policeStationPostOffice: 'Basti Rural PS',
          ),
        ],
      },
      'Bhadohi': {

        'Bhadohi City': [
          const VillageRecord(
            villageName: 'Bhadohi Rural',
            lgdCode: '502130',
            gramPanchayat: 'Bhadohi GP',
            policeStationPostOffice: 'Bhadohi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bhadohi North',
            lgdCode: '502131',
            gramPanchayat: 'Bhadohi Ward 1',
            policeStationPostOffice: 'Bhadohi PS / PO',
          ),
        ],
        'Bhadohi Block': [
          const VillageRecord(
            villageName: 'Bhadohi East',
            lgdCode: '502132',
            gramPanchayat: 'Bhadohi East GP',
            policeStationPostOffice: 'Bhadohi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bhadohi South',
            lgdCode: '502133',
            gramPanchayat: 'Bhadohi South GP',
            policeStationPostOffice: 'Bhadohi Rural PS',
          ),
        ],
      },
      'Bijnor': {

        'Bijnor City': [
          const VillageRecord(
            villageName: 'Bijnor Rural',
            lgdCode: '502134',
            gramPanchayat: 'Bijnor GP',
            policeStationPostOffice: 'Bijnor PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bijnor North',
            lgdCode: '502135',
            gramPanchayat: 'Bijnor Ward 1',
            policeStationPostOffice: 'Bijnor PS / PO',
          ),
        ],
        'Bijnor Block': [
          const VillageRecord(
            villageName: 'Bijnor East',
            lgdCode: '502136',
            gramPanchayat: 'Bijnor East GP',
            policeStationPostOffice: 'Bijnor Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bijnor South',
            lgdCode: '502137',
            gramPanchayat: 'Bijnor South GP',
            policeStationPostOffice: 'Bijnor Rural PS',
          ),
        ],
      },
      'Budaun': {

        'Budaun City': [
          const VillageRecord(
            villageName: 'Budaun Rural',
            lgdCode: '502138',
            gramPanchayat: 'Budaun GP',
            policeStationPostOffice: 'Budaun PS / PO',
          ),
          const VillageRecord(
            villageName: 'Budaun North',
            lgdCode: '502139',
            gramPanchayat: 'Budaun Ward 1',
            policeStationPostOffice: 'Budaun PS / PO',
          ),
        ],
        'Budaun Block': [
          const VillageRecord(
            villageName: 'Budaun East',
            lgdCode: '502140',
            gramPanchayat: 'Budaun East GP',
            policeStationPostOffice: 'Budaun Rural PS',
          ),
          const VillageRecord(
            villageName: 'Budaun South',
            lgdCode: '502141',
            gramPanchayat: 'Budaun South GP',
            policeStationPostOffice: 'Budaun Rural PS',
          ),
        ],
      },
      'Bulandshahr': {

        'Bulandshahr City': [
          const VillageRecord(
            villageName: 'Bulandshahr Rural',
            lgdCode: '502142',
            gramPanchayat: 'Bulandshahr GP',
            policeStationPostOffice: 'Bulandshahr PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bulandshahr North',
            lgdCode: '502143',
            gramPanchayat: 'Bulandshahr Ward 1',
            policeStationPostOffice: 'Bulandshahr PS / PO',
          ),
        ],
        'Bulandshahr Block': [
          const VillageRecord(
            villageName: 'Bulandshahr East',
            lgdCode: '502144',
            gramPanchayat: 'Bulandshahr East GP',
            policeStationPostOffice: 'Bulandshahr Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bulandshahr South',
            lgdCode: '502145',
            gramPanchayat: 'Bulandshahr South GP',
            policeStationPostOffice: 'Bulandshahr Rural PS',
          ),
        ],
      },
      'Chandauli': {

        'Chandauli City': [
          const VillageRecord(
            villageName: 'Chandauli Rural',
            lgdCode: '502146',
            gramPanchayat: 'Chandauli GP',
            policeStationPostOffice: 'Chandauli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chandauli North',
            lgdCode: '502147',
            gramPanchayat: 'Chandauli Ward 1',
            policeStationPostOffice: 'Chandauli PS / PO',
          ),
        ],
        'Chandauli Block': [
          const VillageRecord(
            villageName: 'Chandauli East',
            lgdCode: '502148',
            gramPanchayat: 'Chandauli East GP',
            policeStationPostOffice: 'Chandauli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chandauli South',
            lgdCode: '502149',
            gramPanchayat: 'Chandauli South GP',
            policeStationPostOffice: 'Chandauli Rural PS',
          ),
        ],
      },
      'Chitrakoot': {

        'Chitrakoot City': [
          const VillageRecord(
            villageName: 'Chitrakoot Rural',
            lgdCode: '502150',
            gramPanchayat: 'Chitrakoot GP',
            policeStationPostOffice: 'Chitrakoot PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chitrakoot North',
            lgdCode: '502151',
            gramPanchayat: 'Chitrakoot Ward 1',
            policeStationPostOffice: 'Chitrakoot PS / PO',
          ),
        ],
        'Chitrakoot Block': [
          const VillageRecord(
            villageName: 'Chitrakoot East',
            lgdCode: '502152',
            gramPanchayat: 'Chitrakoot East GP',
            policeStationPostOffice: 'Chitrakoot Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chitrakoot South',
            lgdCode: '502153',
            gramPanchayat: 'Chitrakoot South GP',
            policeStationPostOffice: 'Chitrakoot Rural PS',
          ),
        ],
      },
      'Deoria': {

        'Deoria City': [
          const VillageRecord(
            villageName: 'Deoria Rural',
            lgdCode: '502154',
            gramPanchayat: 'Deoria GP',
            policeStationPostOffice: 'Deoria PS / PO',
          ),
          const VillageRecord(
            villageName: 'Deoria North',
            lgdCode: '502155',
            gramPanchayat: 'Deoria Ward 1',
            policeStationPostOffice: 'Deoria PS / PO',
          ),
        ],
        'Deoria Block': [
          const VillageRecord(
            villageName: 'Deoria East',
            lgdCode: '502156',
            gramPanchayat: 'Deoria East GP',
            policeStationPostOffice: 'Deoria Rural PS',
          ),
          const VillageRecord(
            villageName: 'Deoria South',
            lgdCode: '502157',
            gramPanchayat: 'Deoria South GP',
            policeStationPostOffice: 'Deoria Rural PS',
          ),
        ],
      },
      'Etah': {

        'Etah City': [
          const VillageRecord(
            villageName: 'Etah Rural',
            lgdCode: '502158',
            gramPanchayat: 'Etah GP',
            policeStationPostOffice: 'Etah PS / PO',
          ),
          const VillageRecord(
            villageName: 'Etah North',
            lgdCode: '502159',
            gramPanchayat: 'Etah Ward 1',
            policeStationPostOffice: 'Etah PS / PO',
          ),
        ],
        'Etah Block': [
          const VillageRecord(
            villageName: 'Etah East',
            lgdCode: '502160',
            gramPanchayat: 'Etah East GP',
            policeStationPostOffice: 'Etah Rural PS',
          ),
          const VillageRecord(
            villageName: 'Etah South',
            lgdCode: '502161',
            gramPanchayat: 'Etah South GP',
            policeStationPostOffice: 'Etah Rural PS',
          ),
        ],
      },
      'Etawah': {

        'Etawah City': [
          const VillageRecord(
            villageName: 'Etawah Rural',
            lgdCode: '502162',
            gramPanchayat: 'Etawah GP',
            policeStationPostOffice: 'Etawah PS / PO',
          ),
          const VillageRecord(
            villageName: 'Etawah North',
            lgdCode: '502163',
            gramPanchayat: 'Etawah Ward 1',
            policeStationPostOffice: 'Etawah PS / PO',
          ),
        ],
        'Etawah Block': [
          const VillageRecord(
            villageName: 'Etawah East',
            lgdCode: '502164',
            gramPanchayat: 'Etawah East GP',
            policeStationPostOffice: 'Etawah Rural PS',
          ),
          const VillageRecord(
            villageName: 'Etawah South',
            lgdCode: '502165',
            gramPanchayat: 'Etawah South GP',
            policeStationPostOffice: 'Etawah Rural PS',
          ),
        ],
      },
      'Farrukhabad': {

        'Farrukhabad City': [
          const VillageRecord(
            villageName: 'Farrukhabad Rural',
            lgdCode: '502166',
            gramPanchayat: 'Farrukhabad GP',
            policeStationPostOffice: 'Farrukhabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Farrukhabad North',
            lgdCode: '502167',
            gramPanchayat: 'Farrukhabad Ward 1',
            policeStationPostOffice: 'Farrukhabad PS / PO',
          ),
        ],
        'Farrukhabad Block': [
          const VillageRecord(
            villageName: 'Farrukhabad East',
            lgdCode: '502168',
            gramPanchayat: 'Farrukhabad East GP',
            policeStationPostOffice: 'Farrukhabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Farrukhabad South',
            lgdCode: '502169',
            gramPanchayat: 'Farrukhabad South GP',
            policeStationPostOffice: 'Farrukhabad Rural PS',
          ),
        ],
      },
      'Fatehpur': {

        'Fatehpur City': [
          const VillageRecord(
            villageName: 'Fatehpur Rural',
            lgdCode: '502170',
            gramPanchayat: 'Fatehpur GP',
            policeStationPostOffice: 'Fatehpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Fatehpur North',
            lgdCode: '502171',
            gramPanchayat: 'Fatehpur Ward 1',
            policeStationPostOffice: 'Fatehpur PS / PO',
          ),
        ],
        'Fatehpur Block': [
          const VillageRecord(
            villageName: 'Fatehpur East',
            lgdCode: '502172',
            gramPanchayat: 'Fatehpur East GP',
            policeStationPostOffice: 'Fatehpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Fatehpur South',
            lgdCode: '502173',
            gramPanchayat: 'Fatehpur South GP',
            policeStationPostOffice: 'Fatehpur Rural PS',
          ),
        ],
      },
      'Firozabad': {

        'Firozabad City': [
          const VillageRecord(
            villageName: 'Firozabad Rural',
            lgdCode: '502174',
            gramPanchayat: 'Firozabad GP',
            policeStationPostOffice: 'Firozabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Firozabad North',
            lgdCode: '502175',
            gramPanchayat: 'Firozabad Ward 1',
            policeStationPostOffice: 'Firozabad PS / PO',
          ),
        ],
        'Firozabad Block': [
          const VillageRecord(
            villageName: 'Firozabad East',
            lgdCode: '502176',
            gramPanchayat: 'Firozabad East GP',
            policeStationPostOffice: 'Firozabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Firozabad South',
            lgdCode: '502177',
            gramPanchayat: 'Firozabad South GP',
            policeStationPostOffice: 'Firozabad Rural PS',
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
      'Ghaziabad': {

        'Ghaziabad City': [
          const VillageRecord(
            villageName: 'Ghaziabad Rural',
            lgdCode: '502178',
            gramPanchayat: 'Ghaziabad GP',
            policeStationPostOffice: 'Ghaziabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ghaziabad North',
            lgdCode: '502179',
            gramPanchayat: 'Ghaziabad Ward 1',
            policeStationPostOffice: 'Ghaziabad PS / PO',
          ),
        ],
        'Ghaziabad Block': [
          const VillageRecord(
            villageName: 'Ghaziabad East',
            lgdCode: '502180',
            gramPanchayat: 'Ghaziabad East GP',
            policeStationPostOffice: 'Ghaziabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ghaziabad South',
            lgdCode: '502181',
            gramPanchayat: 'Ghaziabad South GP',
            policeStationPostOffice: 'Ghaziabad Rural PS',
          ),
        ],
      },
      'Ghazipur': {

        'Ghazipur City': [
          const VillageRecord(
            villageName: 'Ghazipur Rural',
            lgdCode: '502182',
            gramPanchayat: 'Ghazipur GP',
            policeStationPostOffice: 'Ghazipur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ghazipur North',
            lgdCode: '502183',
            gramPanchayat: 'Ghazipur Ward 1',
            policeStationPostOffice: 'Ghazipur PS / PO',
          ),
        ],
        'Ghazipur Block': [
          const VillageRecord(
            villageName: 'Ghazipur East',
            lgdCode: '502184',
            gramPanchayat: 'Ghazipur East GP',
            policeStationPostOffice: 'Ghazipur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ghazipur South',
            lgdCode: '502185',
            gramPanchayat: 'Ghazipur South GP',
            policeStationPostOffice: 'Ghazipur Rural PS',
          ),
        ],
      },
      'Gonda': {

        'Gonda City': [
          const VillageRecord(
            villageName: 'Gonda Rural',
            lgdCode: '502186',
            gramPanchayat: 'Gonda GP',
            policeStationPostOffice: 'Gonda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gonda North',
            lgdCode: '502187',
            gramPanchayat: 'Gonda Ward 1',
            policeStationPostOffice: 'Gonda PS / PO',
          ),
        ],
        'Gonda Block': [
          const VillageRecord(
            villageName: 'Gonda East',
            lgdCode: '502188',
            gramPanchayat: 'Gonda East GP',
            policeStationPostOffice: 'Gonda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gonda South',
            lgdCode: '502189',
            gramPanchayat: 'Gonda South GP',
            policeStationPostOffice: 'Gonda Rural PS',
          ),
        ],
      },
      'Gorakhpur': {

        'Gorakhpur City': [
          const VillageRecord(
            villageName: 'Gorakhpur Rural',
            lgdCode: '502190',
            gramPanchayat: 'Gorakhpur GP',
            policeStationPostOffice: 'Gorakhpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Gorakhpur North',
            lgdCode: '502191',
            gramPanchayat: 'Gorakhpur Ward 1',
            policeStationPostOffice: 'Gorakhpur PS / PO',
          ),
        ],
        'Gorakhpur Block': [
          const VillageRecord(
            villageName: 'Gorakhpur East',
            lgdCode: '502192',
            gramPanchayat: 'Gorakhpur East GP',
            policeStationPostOffice: 'Gorakhpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Gorakhpur South',
            lgdCode: '502193',
            gramPanchayat: 'Gorakhpur South GP',
            policeStationPostOffice: 'Gorakhpur Rural PS',
          ),
        ],
      },
      'Hamirpur': {

        'Hamirpur City': [
          const VillageRecord(
            villageName: 'Hamirpur Rural',
            lgdCode: '502194',
            gramPanchayat: 'Hamirpur GP',
            policeStationPostOffice: 'Hamirpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hamirpur North',
            lgdCode: '502195',
            gramPanchayat: 'Hamirpur Ward 1',
            policeStationPostOffice: 'Hamirpur PS / PO',
          ),
        ],
        'Hamirpur Block': [
          const VillageRecord(
            villageName: 'Hamirpur East',
            lgdCode: '502196',
            gramPanchayat: 'Hamirpur East GP',
            policeStationPostOffice: 'Hamirpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hamirpur South',
            lgdCode: '502197',
            gramPanchayat: 'Hamirpur South GP',
            policeStationPostOffice: 'Hamirpur Rural PS',
          ),
        ],
      },
      'Hapur': {

        'Hapur City': [
          const VillageRecord(
            villageName: 'Hapur Rural',
            lgdCode: '502198',
            gramPanchayat: 'Hapur GP',
            policeStationPostOffice: 'Hapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hapur North',
            lgdCode: '502199',
            gramPanchayat: 'Hapur Ward 1',
            policeStationPostOffice: 'Hapur PS / PO',
          ),
        ],
        'Hapur Block': [
          const VillageRecord(
            villageName: 'Hapur East',
            lgdCode: '502200',
            gramPanchayat: 'Hapur East GP',
            policeStationPostOffice: 'Hapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hapur South',
            lgdCode: '502201',
            gramPanchayat: 'Hapur South GP',
            policeStationPostOffice: 'Hapur Rural PS',
          ),
        ],
      },
      'Hardoi': {

        'Hardoi City': [
          const VillageRecord(
            villageName: 'Hardoi Rural',
            lgdCode: '502202',
            gramPanchayat: 'Hardoi GP',
            policeStationPostOffice: 'Hardoi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hardoi North',
            lgdCode: '502203',
            gramPanchayat: 'Hardoi Ward 1',
            policeStationPostOffice: 'Hardoi PS / PO',
          ),
        ],
        'Hardoi Block': [
          const VillageRecord(
            villageName: 'Hardoi East',
            lgdCode: '502204',
            gramPanchayat: 'Hardoi East GP',
            policeStationPostOffice: 'Hardoi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hardoi South',
            lgdCode: '502205',
            gramPanchayat: 'Hardoi South GP',
            policeStationPostOffice: 'Hardoi Rural PS',
          ),
        ],
      },
      'Hathras': {

        'Hathras City': [
          const VillageRecord(
            villageName: 'Hathras Rural',
            lgdCode: '502206',
            gramPanchayat: 'Hathras GP',
            policeStationPostOffice: 'Hathras PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hathras North',
            lgdCode: '502207',
            gramPanchayat: 'Hathras Ward 1',
            policeStationPostOffice: 'Hathras PS / PO',
          ),
        ],
        'Hathras Block': [
          const VillageRecord(
            villageName: 'Hathras East',
            lgdCode: '502208',
            gramPanchayat: 'Hathras East GP',
            policeStationPostOffice: 'Hathras Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hathras South',
            lgdCode: '502209',
            gramPanchayat: 'Hathras South GP',
            policeStationPostOffice: 'Hathras Rural PS',
          ),
        ],
      },
      'Jalaun': {

        'Jalaun City': [
          const VillageRecord(
            villageName: 'Jalaun Rural',
            lgdCode: '502210',
            gramPanchayat: 'Jalaun GP',
            policeStationPostOffice: 'Jalaun PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jalaun North',
            lgdCode: '502211',
            gramPanchayat: 'Jalaun Ward 1',
            policeStationPostOffice: 'Jalaun PS / PO',
          ),
        ],
        'Jalaun Block': [
          const VillageRecord(
            villageName: 'Jalaun East',
            lgdCode: '502212',
            gramPanchayat: 'Jalaun East GP',
            policeStationPostOffice: 'Jalaun Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jalaun South',
            lgdCode: '502213',
            gramPanchayat: 'Jalaun South GP',
            policeStationPostOffice: 'Jalaun Rural PS',
          ),
        ],
      },
      'Jaunpur': {

        'Jaunpur City': [
          const VillageRecord(
            villageName: 'Jaunpur Rural',
            lgdCode: '502214',
            gramPanchayat: 'Jaunpur GP',
            policeStationPostOffice: 'Jaunpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jaunpur North',
            lgdCode: '502215',
            gramPanchayat: 'Jaunpur Ward 1',
            policeStationPostOffice: 'Jaunpur PS / PO',
          ),
        ],
        'Jaunpur Block': [
          const VillageRecord(
            villageName: 'Jaunpur East',
            lgdCode: '502216',
            gramPanchayat: 'Jaunpur East GP',
            policeStationPostOffice: 'Jaunpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jaunpur South',
            lgdCode: '502217',
            gramPanchayat: 'Jaunpur South GP',
            policeStationPostOffice: 'Jaunpur Rural PS',
          ),
        ],
      },
      'Jhansi': {

        'Jhansi City': [
          const VillageRecord(
            villageName: 'Jhansi Rural',
            lgdCode: '502218',
            gramPanchayat: 'Jhansi GP',
            policeStationPostOffice: 'Jhansi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jhansi North',
            lgdCode: '502219',
            gramPanchayat: 'Jhansi Ward 1',
            policeStationPostOffice: 'Jhansi PS / PO',
          ),
        ],
        'Jhansi Block': [
          const VillageRecord(
            villageName: 'Jhansi East',
            lgdCode: '502220',
            gramPanchayat: 'Jhansi East GP',
            policeStationPostOffice: 'Jhansi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jhansi South',
            lgdCode: '502221',
            gramPanchayat: 'Jhansi South GP',
            policeStationPostOffice: 'Jhansi Rural PS',
          ),
        ],
      },
      'Kannauj': {

        'Kannauj City': [
          const VillageRecord(
            villageName: 'Kannauj Rural',
            lgdCode: '502222',
            gramPanchayat: 'Kannauj GP',
            policeStationPostOffice: 'Kannauj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kannauj North',
            lgdCode: '502223',
            gramPanchayat: 'Kannauj Ward 1',
            policeStationPostOffice: 'Kannauj PS / PO',
          ),
        ],
        'Kannauj Block': [
          const VillageRecord(
            villageName: 'Kannauj East',
            lgdCode: '502224',
            gramPanchayat: 'Kannauj East GP',
            policeStationPostOffice: 'Kannauj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kannauj South',
            lgdCode: '502225',
            gramPanchayat: 'Kannauj South GP',
            policeStationPostOffice: 'Kannauj Rural PS',
          ),
        ],
      },
      'Kanpur Dehat': {

        'Kanpur Dehat City': [
          const VillageRecord(
            villageName: 'Kanpur Dehat Rural',
            lgdCode: '502226',
            gramPanchayat: 'Kanpur Dehat GP',
            policeStationPostOffice: 'Kanpur Dehat PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kanpur Dehat North',
            lgdCode: '502227',
            gramPanchayat: 'Kanpur Dehat Ward 1',
            policeStationPostOffice: 'Kanpur Dehat PS / PO',
          ),
        ],
        'Kanpur Dehat Block': [
          const VillageRecord(
            villageName: 'Kanpur Dehat East',
            lgdCode: '502228',
            gramPanchayat: 'Kanpur Dehat East GP',
            policeStationPostOffice: 'Kanpur Dehat Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kanpur Dehat South',
            lgdCode: '502229',
            gramPanchayat: 'Kanpur Dehat South GP',
            policeStationPostOffice: 'Kanpur Dehat Rural PS',
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
      'Kasganj': {

        'Kasganj City': [
          const VillageRecord(
            villageName: 'Kasganj Rural',
            lgdCode: '502230',
            gramPanchayat: 'Kasganj GP',
            policeStationPostOffice: 'Kasganj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kasganj North',
            lgdCode: '502231',
            gramPanchayat: 'Kasganj Ward 1',
            policeStationPostOffice: 'Kasganj PS / PO',
          ),
        ],
        'Kasganj Block': [
          const VillageRecord(
            villageName: 'Kasganj East',
            lgdCode: '502232',
            gramPanchayat: 'Kasganj East GP',
            policeStationPostOffice: 'Kasganj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kasganj South',
            lgdCode: '502233',
            gramPanchayat: 'Kasganj South GP',
            policeStationPostOffice: 'Kasganj Rural PS',
          ),
        ],
      },
      'Kaushambi': {

        'Kaushambi City': [
          const VillageRecord(
            villageName: 'Kaushambi Rural',
            lgdCode: '502234',
            gramPanchayat: 'Kaushambi GP',
            policeStationPostOffice: 'Kaushambi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kaushambi North',
            lgdCode: '502235',
            gramPanchayat: 'Kaushambi Ward 1',
            policeStationPostOffice: 'Kaushambi PS / PO',
          ),
        ],
        'Kaushambi Block': [
          const VillageRecord(
            villageName: 'Kaushambi East',
            lgdCode: '502236',
            gramPanchayat: 'Kaushambi East GP',
            policeStationPostOffice: 'Kaushambi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kaushambi South',
            lgdCode: '502237',
            gramPanchayat: 'Kaushambi South GP',
            policeStationPostOffice: 'Kaushambi Rural PS',
          ),
        ],
      },
      'Kheri': {

        'Kheri City': [
          const VillageRecord(
            villageName: 'Kheri Rural',
            lgdCode: '502238',
            gramPanchayat: 'Kheri GP',
            policeStationPostOffice: 'Kheri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kheri North',
            lgdCode: '502239',
            gramPanchayat: 'Kheri Ward 1',
            policeStationPostOffice: 'Kheri PS / PO',
          ),
        ],
        'Kheri Block': [
          const VillageRecord(
            villageName: 'Kheri East',
            lgdCode: '502240',
            gramPanchayat: 'Kheri East GP',
            policeStationPostOffice: 'Kheri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kheri South',
            lgdCode: '502241',
            gramPanchayat: 'Kheri South GP',
            policeStationPostOffice: 'Kheri Rural PS',
          ),
        ],
      },
      'Kushinagar': {

        'Kushinagar City': [
          const VillageRecord(
            villageName: 'Kushinagar Rural',
            lgdCode: '502242',
            gramPanchayat: 'Kushinagar GP',
            policeStationPostOffice: 'Kushinagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kushinagar North',
            lgdCode: '502243',
            gramPanchayat: 'Kushinagar Ward 1',
            policeStationPostOffice: 'Kushinagar PS / PO',
          ),
        ],
        'Kushinagar Block': [
          const VillageRecord(
            villageName: 'Kushinagar East',
            lgdCode: '502244',
            gramPanchayat: 'Kushinagar East GP',
            policeStationPostOffice: 'Kushinagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kushinagar South',
            lgdCode: '502245',
            gramPanchayat: 'Kushinagar South GP',
            policeStationPostOffice: 'Kushinagar Rural PS',
          ),
        ],
      },
      'Lalitpur': {

        'Lalitpur City': [
          const VillageRecord(
            villageName: 'Lalitpur Rural',
            lgdCode: '502246',
            gramPanchayat: 'Lalitpur GP',
            policeStationPostOffice: 'Lalitpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Lalitpur North',
            lgdCode: '502247',
            gramPanchayat: 'Lalitpur Ward 1',
            policeStationPostOffice: 'Lalitpur PS / PO',
          ),
        ],
        'Lalitpur Block': [
          const VillageRecord(
            villageName: 'Lalitpur East',
            lgdCode: '502248',
            gramPanchayat: 'Lalitpur East GP',
            policeStationPostOffice: 'Lalitpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Lalitpur South',
            lgdCode: '502249',
            gramPanchayat: 'Lalitpur South GP',
            policeStationPostOffice: 'Lalitpur Rural PS',
          ),
        ],
      },
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
      'Maharajganj': {

        'Maharajganj City': [
          const VillageRecord(
            villageName: 'Maharajganj Rural',
            lgdCode: '502250',
            gramPanchayat: 'Maharajganj GP',
            policeStationPostOffice: 'Maharajganj PS / PO',
          ),
          const VillageRecord(
            villageName: 'Maharajganj North',
            lgdCode: '502251',
            gramPanchayat: 'Maharajganj Ward 1',
            policeStationPostOffice: 'Maharajganj PS / PO',
          ),
        ],
        'Maharajganj Block': [
          const VillageRecord(
            villageName: 'Maharajganj East',
            lgdCode: '502252',
            gramPanchayat: 'Maharajganj East GP',
            policeStationPostOffice: 'Maharajganj Rural PS',
          ),
          const VillageRecord(
            villageName: 'Maharajganj South',
            lgdCode: '502253',
            gramPanchayat: 'Maharajganj South GP',
            policeStationPostOffice: 'Maharajganj Rural PS',
          ),
        ],
      },
      'Mahoba': {

        'Mahoba City': [
          const VillageRecord(
            villageName: 'Mahoba Rural',
            lgdCode: '502254',
            gramPanchayat: 'Mahoba GP',
            policeStationPostOffice: 'Mahoba PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mahoba North',
            lgdCode: '502255',
            gramPanchayat: 'Mahoba Ward 1',
            policeStationPostOffice: 'Mahoba PS / PO',
          ),
        ],
        'Mahoba Block': [
          const VillageRecord(
            villageName: 'Mahoba East',
            lgdCode: '502256',
            gramPanchayat: 'Mahoba East GP',
            policeStationPostOffice: 'Mahoba Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mahoba South',
            lgdCode: '502257',
            gramPanchayat: 'Mahoba South GP',
            policeStationPostOffice: 'Mahoba Rural PS',
          ),
        ],
      },
      'Mainpuri': {

        'Mainpuri City': [
          const VillageRecord(
            villageName: 'Mainpuri Rural',
            lgdCode: '502258',
            gramPanchayat: 'Mainpuri GP',
            policeStationPostOffice: 'Mainpuri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mainpuri North',
            lgdCode: '502259',
            gramPanchayat: 'Mainpuri Ward 1',
            policeStationPostOffice: 'Mainpuri PS / PO',
          ),
        ],
        'Mainpuri Block': [
          const VillageRecord(
            villageName: 'Mainpuri East',
            lgdCode: '502260',
            gramPanchayat: 'Mainpuri East GP',
            policeStationPostOffice: 'Mainpuri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mainpuri South',
            lgdCode: '502261',
            gramPanchayat: 'Mainpuri South GP',
            policeStationPostOffice: 'Mainpuri Rural PS',
          ),
        ],
      },
      'Mathura': {

        'Mathura City': [
          const VillageRecord(
            villageName: 'Mathura Rural',
            lgdCode: '502262',
            gramPanchayat: 'Mathura GP',
            policeStationPostOffice: 'Mathura PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mathura North',
            lgdCode: '502263',
            gramPanchayat: 'Mathura Ward 1',
            policeStationPostOffice: 'Mathura PS / PO',
          ),
        ],
        'Mathura Block': [
          const VillageRecord(
            villageName: 'Mathura East',
            lgdCode: '502264',
            gramPanchayat: 'Mathura East GP',
            policeStationPostOffice: 'Mathura Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mathura South',
            lgdCode: '502265',
            gramPanchayat: 'Mathura South GP',
            policeStationPostOffice: 'Mathura Rural PS',
          ),
        ],
      },
      'Mau': {

        'Mau City': [
          const VillageRecord(
            villageName: 'Mau Rural',
            lgdCode: '502266',
            gramPanchayat: 'Mau GP',
            policeStationPostOffice: 'Mau PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mau North',
            lgdCode: '502267',
            gramPanchayat: 'Mau Ward 1',
            policeStationPostOffice: 'Mau PS / PO',
          ),
        ],
        'Mau Block': [
          const VillageRecord(
            villageName: 'Mau East',
            lgdCode: '502268',
            gramPanchayat: 'Mau East GP',
            policeStationPostOffice: 'Mau Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mau South',
            lgdCode: '502269',
            gramPanchayat: 'Mau South GP',
            policeStationPostOffice: 'Mau Rural PS',
          ),
        ],
      },
      'Meerut': {

        'Meerut City': [
          const VillageRecord(
            villageName: 'Meerut Rural',
            lgdCode: '502270',
            gramPanchayat: 'Meerut GP',
            policeStationPostOffice: 'Meerut PS / PO',
          ),
          const VillageRecord(
            villageName: 'Meerut North',
            lgdCode: '502271',
            gramPanchayat: 'Meerut Ward 1',
            policeStationPostOffice: 'Meerut PS / PO',
          ),
        ],
        'Meerut Block': [
          const VillageRecord(
            villageName: 'Meerut East',
            lgdCode: '502272',
            gramPanchayat: 'Meerut East GP',
            policeStationPostOffice: 'Meerut Rural PS',
          ),
          const VillageRecord(
            villageName: 'Meerut South',
            lgdCode: '502273',
            gramPanchayat: 'Meerut South GP',
            policeStationPostOffice: 'Meerut Rural PS',
          ),
        ],
      },
      'Mirzapur': {

        'Mirzapur City': [
          const VillageRecord(
            villageName: 'Mirzapur Rural',
            lgdCode: '502274',
            gramPanchayat: 'Mirzapur GP',
            policeStationPostOffice: 'Mirzapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mirzapur North',
            lgdCode: '502275',
            gramPanchayat: 'Mirzapur Ward 1',
            policeStationPostOffice: 'Mirzapur PS / PO',
          ),
        ],
        'Mirzapur Block': [
          const VillageRecord(
            villageName: 'Mirzapur East',
            lgdCode: '502276',
            gramPanchayat: 'Mirzapur East GP',
            policeStationPostOffice: 'Mirzapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mirzapur South',
            lgdCode: '502277',
            gramPanchayat: 'Mirzapur South GP',
            policeStationPostOffice: 'Mirzapur Rural PS',
          ),
        ],
      },
      'Moradabad': {

        'Moradabad City': [
          const VillageRecord(
            villageName: 'Moradabad Rural',
            lgdCode: '502278',
            gramPanchayat: 'Moradabad GP',
            policeStationPostOffice: 'Moradabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Moradabad North',
            lgdCode: '502279',
            gramPanchayat: 'Moradabad Ward 1',
            policeStationPostOffice: 'Moradabad PS / PO',
          ),
        ],
        'Moradabad Block': [
          const VillageRecord(
            villageName: 'Moradabad East',
            lgdCode: '502280',
            gramPanchayat: 'Moradabad East GP',
            policeStationPostOffice: 'Moradabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Moradabad South',
            lgdCode: '502281',
            gramPanchayat: 'Moradabad South GP',
            policeStationPostOffice: 'Moradabad Rural PS',
          ),
        ],
      },
      'Muzaffarnagar': {

        'Muzaffarnagar City': [
          const VillageRecord(
            villageName: 'Muzaffarnagar Rural',
            lgdCode: '502282',
            gramPanchayat: 'Muzaffarnagar GP',
            policeStationPostOffice: 'Muzaffarnagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Muzaffarnagar North',
            lgdCode: '502283',
            gramPanchayat: 'Muzaffarnagar Ward 1',
            policeStationPostOffice: 'Muzaffarnagar PS / PO',
          ),
        ],
        'Muzaffarnagar Block': [
          const VillageRecord(
            villageName: 'Muzaffarnagar East',
            lgdCode: '502284',
            gramPanchayat: 'Muzaffarnagar East GP',
            policeStationPostOffice: 'Muzaffarnagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Muzaffarnagar South',
            lgdCode: '502285',
            gramPanchayat: 'Muzaffarnagar South GP',
            policeStationPostOffice: 'Muzaffarnagar Rural PS',
          ),
        ],
      },
      'Pilibhit': {

        'Pilibhit City': [
          const VillageRecord(
            villageName: 'Pilibhit Rural',
            lgdCode: '502286',
            gramPanchayat: 'Pilibhit GP',
            policeStationPostOffice: 'Pilibhit PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pilibhit North',
            lgdCode: '502287',
            gramPanchayat: 'Pilibhit Ward 1',
            policeStationPostOffice: 'Pilibhit PS / PO',
          ),
        ],
        'Pilibhit Block': [
          const VillageRecord(
            villageName: 'Pilibhit East',
            lgdCode: '502288',
            gramPanchayat: 'Pilibhit East GP',
            policeStationPostOffice: 'Pilibhit Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pilibhit South',
            lgdCode: '502289',
            gramPanchayat: 'Pilibhit South GP',
            policeStationPostOffice: 'Pilibhit Rural PS',
          ),
        ],
      },
      'Pratapgarh': {

        'Pratapgarh City': [
          const VillageRecord(
            villageName: 'Pratapgarh Rural',
            lgdCode: '502290',
            gramPanchayat: 'Pratapgarh GP',
            policeStationPostOffice: 'Pratapgarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pratapgarh North',
            lgdCode: '502291',
            gramPanchayat: 'Pratapgarh Ward 1',
            policeStationPostOffice: 'Pratapgarh PS / PO',
          ),
        ],
        'Pratapgarh Block': [
          const VillageRecord(
            villageName: 'Pratapgarh East',
            lgdCode: '502292',
            gramPanchayat: 'Pratapgarh East GP',
            policeStationPostOffice: 'Pratapgarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pratapgarh South',
            lgdCode: '502293',
            gramPanchayat: 'Pratapgarh South GP',
            policeStationPostOffice: 'Pratapgarh Rural PS',
          ),
        ],
      },
      'Prayagraj': {


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
      'Raebareli': {

        'Raebareli City': [
          const VillageRecord(
            villageName: 'Raebareli Rural',
            lgdCode: '502294',
            gramPanchayat: 'Raebareli GP',
            policeStationPostOffice: 'Raebareli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Raebareli North',
            lgdCode: '502295',
            gramPanchayat: 'Raebareli Ward 1',
            policeStationPostOffice: 'Raebareli PS / PO',
          ),
        ],
        'Raebareli Block': [
          const VillageRecord(
            villageName: 'Raebareli East',
            lgdCode: '502296',
            gramPanchayat: 'Raebareli East GP',
            policeStationPostOffice: 'Raebareli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Raebareli South',
            lgdCode: '502297',
            gramPanchayat: 'Raebareli South GP',
            policeStationPostOffice: 'Raebareli Rural PS',
          ),
        ],
      },
      'Rampur': {

        'Balrampur City': [
          const VillageRecord(
            villageName: 'Balrampur Rural',
            lgdCode: '502110',
            gramPanchayat: 'Balrampur GP',
            policeStationPostOffice: 'Balrampur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Balrampur North',
            lgdCode: '502111',
            gramPanchayat: 'Balrampur Ward 1',
            policeStationPostOffice: 'Balrampur PS / PO',
          ),
        ],
        'Balrampur Block': [
          const VillageRecord(
            villageName: 'Balrampur East',
            lgdCode: '502112',
            gramPanchayat: 'Balrampur East GP',
            policeStationPostOffice: 'Balrampur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Balrampur South',
            lgdCode: '502113',
            gramPanchayat: 'Balrampur South GP',
            policeStationPostOffice: 'Balrampur Rural PS',
          ),
        ],
      },
      'Saharanpur': {

        'Saharanpur City': [
          const VillageRecord(
            villageName: 'Saharanpur Rural',
            lgdCode: '502302',
            gramPanchayat: 'Saharanpur GP',
            policeStationPostOffice: 'Saharanpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Saharanpur North',
            lgdCode: '502303',
            gramPanchayat: 'Saharanpur Ward 1',
            policeStationPostOffice: 'Saharanpur PS / PO',
          ),
        ],
        'Saharanpur Block': [
          const VillageRecord(
            villageName: 'Saharanpur East',
            lgdCode: '502304',
            gramPanchayat: 'Saharanpur East GP',
            policeStationPostOffice: 'Saharanpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Saharanpur South',
            lgdCode: '502305',
            gramPanchayat: 'Saharanpur South GP',
            policeStationPostOffice: 'Saharanpur Rural PS',
          ),
        ],
      },
      'Sambhal': {

        'Sambhal City': [
          const VillageRecord(
            villageName: 'Sambhal Rural',
            lgdCode: '502306',
            gramPanchayat: 'Sambhal GP',
            policeStationPostOffice: 'Sambhal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sambhal North',
            lgdCode: '502307',
            gramPanchayat: 'Sambhal Ward 1',
            policeStationPostOffice: 'Sambhal PS / PO',
          ),
        ],
        'Sambhal Block': [
          const VillageRecord(
            villageName: 'Sambhal East',
            lgdCode: '502308',
            gramPanchayat: 'Sambhal East GP',
            policeStationPostOffice: 'Sambhal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sambhal South',
            lgdCode: '502309',
            gramPanchayat: 'Sambhal South GP',
            policeStationPostOffice: 'Sambhal Rural PS',
          ),
        ],
      },
      'Sant Kabir Nagar': {

        'Sant Kabir Nagar City': [
          const VillageRecord(
            villageName: 'Sant Kabir Nagar Rural',
            lgdCode: '502310',
            gramPanchayat: 'Sant Kabir Nagar GP',
            policeStationPostOffice: 'Sant Kabir Nagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sant Kabir Nagar North',
            lgdCode: '502311',
            gramPanchayat: 'Sant Kabir Nagar Ward 1',
            policeStationPostOffice: 'Sant Kabir Nagar PS / PO',
          ),
        ],
        'Sant Kabir Nagar Block': [
          const VillageRecord(
            villageName: 'Sant Kabir Nagar East',
            lgdCode: '502312',
            gramPanchayat: 'Sant Kabir Nagar East GP',
            policeStationPostOffice: 'Sant Kabir Nagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sant Kabir Nagar South',
            lgdCode: '502313',
            gramPanchayat: 'Sant Kabir Nagar South GP',
            policeStationPostOffice: 'Sant Kabir Nagar Rural PS',
          ),
        ],
      },
      'Shahjahanpur': {

        'Shahjahanpur City': [
          const VillageRecord(
            villageName: 'Shahjahanpur Rural',
            lgdCode: '502314',
            gramPanchayat: 'Shahjahanpur GP',
            policeStationPostOffice: 'Shahjahanpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shahjahanpur North',
            lgdCode: '502315',
            gramPanchayat: 'Shahjahanpur Ward 1',
            policeStationPostOffice: 'Shahjahanpur PS / PO',
          ),
        ],
        'Shahjahanpur Block': [
          const VillageRecord(
            villageName: 'Shahjahanpur East',
            lgdCode: '502316',
            gramPanchayat: 'Shahjahanpur East GP',
            policeStationPostOffice: 'Shahjahanpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shahjahanpur South',
            lgdCode: '502317',
            gramPanchayat: 'Shahjahanpur South GP',
            policeStationPostOffice: 'Shahjahanpur Rural PS',
          ),
        ],
      },
      'Shamli': {

        'Shamli City': [
          const VillageRecord(
            villageName: 'Shamli Rural',
            lgdCode: '502318',
            gramPanchayat: 'Shamli GP',
            policeStationPostOffice: 'Shamli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shamli North',
            lgdCode: '502319',
            gramPanchayat: 'Shamli Ward 1',
            policeStationPostOffice: 'Shamli PS / PO',
          ),
        ],
        'Shamli Block': [
          const VillageRecord(
            villageName: 'Shamli East',
            lgdCode: '502320',
            gramPanchayat: 'Shamli East GP',
            policeStationPostOffice: 'Shamli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shamli South',
            lgdCode: '502321',
            gramPanchayat: 'Shamli South GP',
            policeStationPostOffice: 'Shamli Rural PS',
          ),
        ],
      },
      'Shravasti': {

        'Shravasti City': [
          const VillageRecord(
            villageName: 'Shravasti Rural',
            lgdCode: '502322',
            gramPanchayat: 'Shravasti GP',
            policeStationPostOffice: 'Shravasti PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shravasti North',
            lgdCode: '502323',
            gramPanchayat: 'Shravasti Ward 1',
            policeStationPostOffice: 'Shravasti PS / PO',
          ),
        ],
        'Shravasti Block': [
          const VillageRecord(
            villageName: 'Shravasti East',
            lgdCode: '502324',
            gramPanchayat: 'Shravasti East GP',
            policeStationPostOffice: 'Shravasti Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shravasti South',
            lgdCode: '502325',
            gramPanchayat: 'Shravasti South GP',
            policeStationPostOffice: 'Shravasti Rural PS',
          ),
        ],
      },
      'Siddharthnagar': {

        'Siddharthnagar City': [
          const VillageRecord(
            villageName: 'Siddharthnagar Rural',
            lgdCode: '502326',
            gramPanchayat: 'Siddharthnagar GP',
            policeStationPostOffice: 'Siddharthnagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Siddharthnagar North',
            lgdCode: '502327',
            gramPanchayat: 'Siddharthnagar Ward 1',
            policeStationPostOffice: 'Siddharthnagar PS / PO',
          ),
        ],
        'Siddharthnagar Block': [
          const VillageRecord(
            villageName: 'Siddharthnagar East',
            lgdCode: '502328',
            gramPanchayat: 'Siddharthnagar East GP',
            policeStationPostOffice: 'Siddharthnagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Siddharthnagar South',
            lgdCode: '502329',
            gramPanchayat: 'Siddharthnagar South GP',
            policeStationPostOffice: 'Siddharthnagar Rural PS',
          ),
        ],
      },
      'Sitapur': {

        'Sitapur City': [
          const VillageRecord(
            villageName: 'Sitapur Rural',
            lgdCode: '502330',
            gramPanchayat: 'Sitapur GP',
            policeStationPostOffice: 'Sitapur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sitapur North',
            lgdCode: '502331',
            gramPanchayat: 'Sitapur Ward 1',
            policeStationPostOffice: 'Sitapur PS / PO',
          ),
        ],
        'Sitapur Block': [
          const VillageRecord(
            villageName: 'Sitapur East',
            lgdCode: '502332',
            gramPanchayat: 'Sitapur East GP',
            policeStationPostOffice: 'Sitapur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sitapur South',
            lgdCode: '502333',
            gramPanchayat: 'Sitapur South GP',
            policeStationPostOffice: 'Sitapur Rural PS',
          ),
        ],
      },
      'Sonbhadra': {

        'Sonbhadra City': [
          const VillageRecord(
            villageName: 'Sonbhadra Rural',
            lgdCode: '502334',
            gramPanchayat: 'Sonbhadra GP',
            policeStationPostOffice: 'Sonbhadra PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sonbhadra North',
            lgdCode: '502335',
            gramPanchayat: 'Sonbhadra Ward 1',
            policeStationPostOffice: 'Sonbhadra PS / PO',
          ),
        ],
        'Sonbhadra Block': [
          const VillageRecord(
            villageName: 'Sonbhadra East',
            lgdCode: '502336',
            gramPanchayat: 'Sonbhadra East GP',
            policeStationPostOffice: 'Sonbhadra Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sonbhadra South',
            lgdCode: '502337',
            gramPanchayat: 'Sonbhadra South GP',
            policeStationPostOffice: 'Sonbhadra Rural PS',
          ),
        ],
      },
      'Sultanpur': {

        'Sultanpur City': [
          const VillageRecord(
            villageName: 'Sultanpur Rural',
            lgdCode: '502338',
            gramPanchayat: 'Sultanpur GP',
            policeStationPostOffice: 'Sultanpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Sultanpur North',
            lgdCode: '502339',
            gramPanchayat: 'Sultanpur Ward 1',
            policeStationPostOffice: 'Sultanpur PS / PO',
          ),
        ],
        'Sultanpur Block': [
          const VillageRecord(
            villageName: 'Sultanpur East',
            lgdCode: '502340',
            gramPanchayat: 'Sultanpur East GP',
            policeStationPostOffice: 'Sultanpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Sultanpur South',
            lgdCode: '502341',
            gramPanchayat: 'Sultanpur South GP',
            policeStationPostOffice: 'Sultanpur Rural PS',
          ),
        ],
      },
      'Unnao': {

        'Unnao City': [
          const VillageRecord(
            villageName: 'Unnao Rural',
            lgdCode: '502342',
            gramPanchayat: 'Unnao GP',
            policeStationPostOffice: 'Unnao PS / PO',
          ),
          const VillageRecord(
            villageName: 'Unnao North',
            lgdCode: '502343',
            gramPanchayat: 'Unnao Ward 1',
            policeStationPostOffice: 'Unnao PS / PO',
          ),
        ],
        'Unnao Block': [
          const VillageRecord(
            villageName: 'Unnao East',
            lgdCode: '502344',
            gramPanchayat: 'Unnao East GP',
            policeStationPostOffice: 'Unnao Rural PS',
          ),
          const VillageRecord(
            villageName: 'Unnao South',
            lgdCode: '502345',
            gramPanchayat: 'Unnao South GP',
            policeStationPostOffice: 'Unnao Rural PS',
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
    },
    'Uttarakhand': {
      'Almora': {

        'Almora City': [
          const VillageRecord(
            villageName: 'Almora Rural',
            lgdCode: '502346',
            gramPanchayat: 'Almora GP',
            policeStationPostOffice: 'Almora PS / PO',
          ),
          const VillageRecord(
            villageName: 'Almora North',
            lgdCode: '502347',
            gramPanchayat: 'Almora Ward 1',
            policeStationPostOffice: 'Almora PS / PO',
          ),
        ],
        'Almora Block': [
          const VillageRecord(
            villageName: 'Almora East',
            lgdCode: '502348',
            gramPanchayat: 'Almora East GP',
            policeStationPostOffice: 'Almora Rural PS',
          ),
          const VillageRecord(
            villageName: 'Almora South',
            lgdCode: '502349',
            gramPanchayat: 'Almora South GP',
            policeStationPostOffice: 'Almora Rural PS',
          ),
        ],
      },
      'Bageshwar': {

        'Bageshwar City': [
          const VillageRecord(
            villageName: 'Bageshwar Rural',
            lgdCode: '502350',
            gramPanchayat: 'Bageshwar GP',
            policeStationPostOffice: 'Bageshwar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bageshwar North',
            lgdCode: '502351',
            gramPanchayat: 'Bageshwar Ward 1',
            policeStationPostOffice: 'Bageshwar PS / PO',
          ),
        ],
        'Bageshwar Block': [
          const VillageRecord(
            villageName: 'Bageshwar East',
            lgdCode: '502352',
            gramPanchayat: 'Bageshwar East GP',
            policeStationPostOffice: 'Bageshwar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bageshwar South',
            lgdCode: '502353',
            gramPanchayat: 'Bageshwar South GP',
            policeStationPostOffice: 'Bageshwar Rural PS',
          ),
        ],
      },
      'Chamoli': {

        'Chamoli City': [
          const VillageRecord(
            villageName: 'Chamoli Rural',
            lgdCode: '502354',
            gramPanchayat: 'Chamoli GP',
            policeStationPostOffice: 'Chamoli PS / PO',
          ),
          const VillageRecord(
            villageName: 'Chamoli North',
            lgdCode: '502355',
            gramPanchayat: 'Chamoli Ward 1',
            policeStationPostOffice: 'Chamoli PS / PO',
          ),
        ],
        'Chamoli Block': [
          const VillageRecord(
            villageName: 'Chamoli East',
            lgdCode: '502356',
            gramPanchayat: 'Chamoli East GP',
            policeStationPostOffice: 'Chamoli Rural PS',
          ),
          const VillageRecord(
            villageName: 'Chamoli South',
            lgdCode: '502357',
            gramPanchayat: 'Chamoli South GP',
            policeStationPostOffice: 'Chamoli Rural PS',
          ),
        ],
      },
      'Champawat': {

        'Champawat City': [
          const VillageRecord(
            villageName: 'Champawat Rural',
            lgdCode: '502358',
            gramPanchayat: 'Champawat GP',
            policeStationPostOffice: 'Champawat PS / PO',
          ),
          const VillageRecord(
            villageName: 'Champawat North',
            lgdCode: '502359',
            gramPanchayat: 'Champawat Ward 1',
            policeStationPostOffice: 'Champawat PS / PO',
          ),
        ],
        'Champawat Block': [
          const VillageRecord(
            villageName: 'Champawat East',
            lgdCode: '502360',
            gramPanchayat: 'Champawat East GP',
            policeStationPostOffice: 'Champawat Rural PS',
          ),
          const VillageRecord(
            villageName: 'Champawat South',
            lgdCode: '502361',
            gramPanchayat: 'Champawat South GP',
            policeStationPostOffice: 'Champawat Rural PS',
          ),
        ],
      },
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
      'Pauri Garhwal': {

        'Pauri Garhwal City': [
          const VillageRecord(
            villageName: 'Pauri Garhwal Rural',
            lgdCode: '502362',
            gramPanchayat: 'Pauri Garhwal GP',
            policeStationPostOffice: 'Pauri Garhwal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pauri Garhwal North',
            lgdCode: '502363',
            gramPanchayat: 'Pauri Garhwal Ward 1',
            policeStationPostOffice: 'Pauri Garhwal PS / PO',
          ),
        ],
        'Pauri Garhwal Block': [
          const VillageRecord(
            villageName: 'Pauri Garhwal East',
            lgdCode: '502364',
            gramPanchayat: 'Pauri Garhwal East GP',
            policeStationPostOffice: 'Pauri Garhwal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pauri Garhwal South',
            lgdCode: '502365',
            gramPanchayat: 'Pauri Garhwal South GP',
            policeStationPostOffice: 'Pauri Garhwal Rural PS',
          ),
        ],
      },
      'Pithoragarh': {

        'Pithoragarh City': [
          const VillageRecord(
            villageName: 'Pithoragarh Rural',
            lgdCode: '502366',
            gramPanchayat: 'Pithoragarh GP',
            policeStationPostOffice: 'Pithoragarh PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pithoragarh North',
            lgdCode: '502367',
            gramPanchayat: 'Pithoragarh Ward 1',
            policeStationPostOffice: 'Pithoragarh PS / PO',
          ),
        ],
        'Pithoragarh Block': [
          const VillageRecord(
            villageName: 'Pithoragarh East',
            lgdCode: '502368',
            gramPanchayat: 'Pithoragarh East GP',
            policeStationPostOffice: 'Pithoragarh Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pithoragarh South',
            lgdCode: '502369',
            gramPanchayat: 'Pithoragarh South GP',
            policeStationPostOffice: 'Pithoragarh Rural PS',
          ),
        ],
      },
      'Rudraprayag': {

        'Rudraprayag City': [
          const VillageRecord(
            villageName: 'Rudraprayag Rural',
            lgdCode: '502370',
            gramPanchayat: 'Rudraprayag GP',
            policeStationPostOffice: 'Rudraprayag PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rudraprayag North',
            lgdCode: '502371',
            gramPanchayat: 'Rudraprayag Ward 1',
            policeStationPostOffice: 'Rudraprayag PS / PO',
          ),
        ],
        'Rudraprayag Block': [
          const VillageRecord(
            villageName: 'Rudraprayag East',
            lgdCode: '502372',
            gramPanchayat: 'Rudraprayag East GP',
            policeStationPostOffice: 'Rudraprayag Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rudraprayag South',
            lgdCode: '502373',
            gramPanchayat: 'Rudraprayag South GP',
            policeStationPostOffice: 'Rudraprayag Rural PS',
          ),
        ],
      },
      'Tehri Garhwal': {

        'Tehri Garhwal City': [
          const VillageRecord(
            villageName: 'Tehri Garhwal Rural',
            lgdCode: '502374',
            gramPanchayat: 'Tehri Garhwal GP',
            policeStationPostOffice: 'Tehri Garhwal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Tehri Garhwal North',
            lgdCode: '502375',
            gramPanchayat: 'Tehri Garhwal Ward 1',
            policeStationPostOffice: 'Tehri Garhwal PS / PO',
          ),
        ],
        'Tehri Garhwal Block': [
          const VillageRecord(
            villageName: 'Tehri Garhwal East',
            lgdCode: '502376',
            gramPanchayat: 'Tehri Garhwal East GP',
            policeStationPostOffice: 'Tehri Garhwal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Tehri Garhwal South',
            lgdCode: '502377',
            gramPanchayat: 'Tehri Garhwal South GP',
            policeStationPostOffice: 'Tehri Garhwal Rural PS',
          ),
        ],
      },
      'Udham Singh Nagar': {

        'Udham Singh Nagar City': [
          const VillageRecord(
            villageName: 'Udham Singh Nagar Rural',
            lgdCode: '502378',
            gramPanchayat: 'Udham Singh Nagar GP',
            policeStationPostOffice: 'Udham Singh Nagar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Udham Singh Nagar North',
            lgdCode: '502379',
            gramPanchayat: 'Udham Singh Nagar Ward 1',
            policeStationPostOffice: 'Udham Singh Nagar PS / PO',
          ),
        ],
        'Udham Singh Nagar Block': [
          const VillageRecord(
            villageName: 'Udham Singh Nagar East',
            lgdCode: '502380',
            gramPanchayat: 'Udham Singh Nagar East GP',
            policeStationPostOffice: 'Udham Singh Nagar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Udham Singh Nagar South',
            lgdCode: '502381',
            gramPanchayat: 'Udham Singh Nagar South GP',
            policeStationPostOffice: 'Udham Singh Nagar Rural PS',
          ),
        ],
      },
      'Uttarkashi': {

        'Uttarkashi City': [
          const VillageRecord(
            villageName: 'Uttarkashi Rural',
            lgdCode: '502382',
            gramPanchayat: 'Uttarkashi GP',
            policeStationPostOffice: 'Uttarkashi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Uttarkashi North',
            lgdCode: '502383',
            gramPanchayat: 'Uttarkashi Ward 1',
            policeStationPostOffice: 'Uttarkashi PS / PO',
          ),
        ],
        'Uttarkashi Block': [
          const VillageRecord(
            villageName: 'Uttarkashi East',
            lgdCode: '502384',
            gramPanchayat: 'Uttarkashi East GP',
            policeStationPostOffice: 'Uttarkashi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Uttarkashi South',
            lgdCode: '502385',
            gramPanchayat: 'Uttarkashi South GP',
            policeStationPostOffice: 'Uttarkashi Rural PS',
          ),
        ],
      },
    },
    'West Bengal': {
      'Alipurduar': {

        'Alipurduar City': [
          const VillageRecord(
            villageName: 'Alipurduar Rural',
            lgdCode: '502386',
            gramPanchayat: 'Alipurduar GP',
            policeStationPostOffice: 'Alipurduar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Alipurduar North',
            lgdCode: '502387',
            gramPanchayat: 'Alipurduar Ward 1',
            policeStationPostOffice: 'Alipurduar PS / PO',
          ),
        ],
        'Alipurduar Block': [
          const VillageRecord(
            villageName: 'Alipurduar East',
            lgdCode: '502388',
            gramPanchayat: 'Alipurduar East GP',
            policeStationPostOffice: 'Alipurduar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Alipurduar South',
            lgdCode: '502389',
            gramPanchayat: 'Alipurduar South GP',
            policeStationPostOffice: 'Alipurduar Rural PS',
          ),
        ],
      },
      'Bankura': {

        'Bankura City': [
          const VillageRecord(
            villageName: 'Bankura Rural',
            lgdCode: '502390',
            gramPanchayat: 'Bankura GP',
            policeStationPostOffice: 'Bankura PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bankura North',
            lgdCode: '502391',
            gramPanchayat: 'Bankura Ward 1',
            policeStationPostOffice: 'Bankura PS / PO',
          ),
        ],
        'Bankura Block': [
          const VillageRecord(
            villageName: 'Bankura East',
            lgdCode: '502392',
            gramPanchayat: 'Bankura East GP',
            policeStationPostOffice: 'Bankura Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bankura South',
            lgdCode: '502393',
            gramPanchayat: 'Bankura South GP',
            policeStationPostOffice: 'Bankura Rural PS',
          ),
        ],
      },
      'Birbhum': {

        'Birbhum City': [
          const VillageRecord(
            villageName: 'Birbhum Rural',
            lgdCode: '502394',
            gramPanchayat: 'Birbhum GP',
            policeStationPostOffice: 'Birbhum PS / PO',
          ),
          const VillageRecord(
            villageName: 'Birbhum North',
            lgdCode: '502395',
            gramPanchayat: 'Birbhum Ward 1',
            policeStationPostOffice: 'Birbhum PS / PO',
          ),
        ],
        'Birbhum Block': [
          const VillageRecord(
            villageName: 'Birbhum East',
            lgdCode: '502396',
            gramPanchayat: 'Birbhum East GP',
            policeStationPostOffice: 'Birbhum Rural PS',
          ),
          const VillageRecord(
            villageName: 'Birbhum South',
            lgdCode: '502397',
            gramPanchayat: 'Birbhum South GP',
            policeStationPostOffice: 'Birbhum Rural PS',
          ),
        ],
      },
      'Cooch Behar': {

        'Cooch Behar City': [
          const VillageRecord(
            villageName: 'Cooch Behar Rural',
            lgdCode: '502398',
            gramPanchayat: 'Cooch Behar GP',
            policeStationPostOffice: 'Cooch Behar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Cooch Behar North',
            lgdCode: '502399',
            gramPanchayat: 'Cooch Behar Ward 1',
            policeStationPostOffice: 'Cooch Behar PS / PO',
          ),
        ],
        'Cooch Behar Block': [
          const VillageRecord(
            villageName: 'Cooch Behar East',
            lgdCode: '502400',
            gramPanchayat: 'Cooch Behar East GP',
            policeStationPostOffice: 'Cooch Behar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Cooch Behar South',
            lgdCode: '502401',
            gramPanchayat: 'Cooch Behar South GP',
            policeStationPostOffice: 'Cooch Behar Rural PS',
          ),
        ],
      },
      'Dakshin Dinajpur': {

        'Dakshin Dinajpur City': [
          const VillageRecord(
            villageName: 'Dakshin Dinajpur Rural',
            lgdCode: '502402',
            gramPanchayat: 'Dakshin Dinajpur GP',
            policeStationPostOffice: 'Dakshin Dinajpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Dakshin Dinajpur North',
            lgdCode: '502403',
            gramPanchayat: 'Dakshin Dinajpur Ward 1',
            policeStationPostOffice: 'Dakshin Dinajpur PS / PO',
          ),
        ],
        'Dakshin Dinajpur Block': [
          const VillageRecord(
            villageName: 'Dakshin Dinajpur East',
            lgdCode: '502404',
            gramPanchayat: 'Dakshin Dinajpur East GP',
            policeStationPostOffice: 'Dakshin Dinajpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Dakshin Dinajpur South',
            lgdCode: '502405',
            gramPanchayat: 'Dakshin Dinajpur South GP',
            policeStationPostOffice: 'Dakshin Dinajpur Rural PS',
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
      'Hooghly': {

        'Hooghly City': [
          const VillageRecord(
            villageName: 'Hooghly Rural',
            lgdCode: '502406',
            gramPanchayat: 'Hooghly GP',
            policeStationPostOffice: 'Hooghly PS / PO',
          ),
          const VillageRecord(
            villageName: 'Hooghly North',
            lgdCode: '502407',
            gramPanchayat: 'Hooghly Ward 1',
            policeStationPostOffice: 'Hooghly PS / PO',
          ),
        ],
        'Hooghly Block': [
          const VillageRecord(
            villageName: 'Hooghly East',
            lgdCode: '502408',
            gramPanchayat: 'Hooghly East GP',
            policeStationPostOffice: 'Hooghly Rural PS',
          ),
          const VillageRecord(
            villageName: 'Hooghly South',
            lgdCode: '502409',
            gramPanchayat: 'Hooghly South GP',
            policeStationPostOffice: 'Hooghly Rural PS',
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
      'Jalpaiguri': {

        'Jalpaiguri City': [
          const VillageRecord(
            villageName: 'Jalpaiguri Rural',
            lgdCode: '502410',
            gramPanchayat: 'Jalpaiguri GP',
            policeStationPostOffice: 'Jalpaiguri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jalpaiguri North',
            lgdCode: '502411',
            gramPanchayat: 'Jalpaiguri Ward 1',
            policeStationPostOffice: 'Jalpaiguri PS / PO',
          ),
        ],
        'Jalpaiguri Block': [
          const VillageRecord(
            villageName: 'Jalpaiguri East',
            lgdCode: '502412',
            gramPanchayat: 'Jalpaiguri East GP',
            policeStationPostOffice: 'Jalpaiguri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jalpaiguri South',
            lgdCode: '502413',
            gramPanchayat: 'Jalpaiguri South GP',
            policeStationPostOffice: 'Jalpaiguri Rural PS',
          ),
        ],
      },
      'Jhargram': {

        'Jhargram City': [
          const VillageRecord(
            villageName: 'Jhargram Rural',
            lgdCode: '502414',
            gramPanchayat: 'Jhargram GP',
            policeStationPostOffice: 'Jhargram PS / PO',
          ),
          const VillageRecord(
            villageName: 'Jhargram North',
            lgdCode: '502415',
            gramPanchayat: 'Jhargram Ward 1',
            policeStationPostOffice: 'Jhargram PS / PO',
          ),
        ],
        'Jhargram Block': [
          const VillageRecord(
            villageName: 'Jhargram East',
            lgdCode: '502416',
            gramPanchayat: 'Jhargram East GP',
            policeStationPostOffice: 'Jhargram Rural PS',
          ),
          const VillageRecord(
            villageName: 'Jhargram South',
            lgdCode: '502417',
            gramPanchayat: 'Jhargram South GP',
            policeStationPostOffice: 'Jhargram Rural PS',
          ),
        ],
      },
      'Kalimpong': {

        'Kalimpong City': [
          const VillageRecord(
            villageName: 'Kalimpong Rural',
            lgdCode: '502418',
            gramPanchayat: 'Kalimpong GP',
            policeStationPostOffice: 'Kalimpong PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kalimpong North',
            lgdCode: '502419',
            gramPanchayat: 'Kalimpong Ward 1',
            policeStationPostOffice: 'Kalimpong PS / PO',
          ),
        ],
        'Kalimpong Block': [
          const VillageRecord(
            villageName: 'Kalimpong East',
            lgdCode: '502420',
            gramPanchayat: 'Kalimpong East GP',
            policeStationPostOffice: 'Kalimpong Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kalimpong South',
            lgdCode: '502421',
            gramPanchayat: 'Kalimpong South GP',
            policeStationPostOffice: 'Kalimpong Rural PS',
          ),
        ],
      },
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
      'Malda': {

        'Malda City': [
          const VillageRecord(
            villageName: 'Malda Rural',
            lgdCode: '502422',
            gramPanchayat: 'Malda GP',
            policeStationPostOffice: 'Malda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Malda North',
            lgdCode: '502423',
            gramPanchayat: 'Malda Ward 1',
            policeStationPostOffice: 'Malda PS / PO',
          ),
        ],
        'Malda Block': [
          const VillageRecord(
            villageName: 'Malda East',
            lgdCode: '502424',
            gramPanchayat: 'Malda East GP',
            policeStationPostOffice: 'Malda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Malda South',
            lgdCode: '502425',
            gramPanchayat: 'Malda South GP',
            policeStationPostOffice: 'Malda Rural PS',
          ),
        ],
      },
      'Murshidabad': {

        'Murshidabad City': [
          const VillageRecord(
            villageName: 'Murshidabad Rural',
            lgdCode: '502426',
            gramPanchayat: 'Murshidabad GP',
            policeStationPostOffice: 'Murshidabad PS / PO',
          ),
          const VillageRecord(
            villageName: 'Murshidabad North',
            lgdCode: '502427',
            gramPanchayat: 'Murshidabad Ward 1',
            policeStationPostOffice: 'Murshidabad PS / PO',
          ),
        ],
        'Murshidabad Block': [
          const VillageRecord(
            villageName: 'Murshidabad East',
            lgdCode: '502428',
            gramPanchayat: 'Murshidabad East GP',
            policeStationPostOffice: 'Murshidabad Rural PS',
          ),
          const VillageRecord(
            villageName: 'Murshidabad South',
            lgdCode: '502429',
            gramPanchayat: 'Murshidabad South GP',
            policeStationPostOffice: 'Murshidabad Rural PS',
          ),
        ],
      },
      'Nadia': {

        'Nadia City': [
          const VillageRecord(
            villageName: 'Nadia Rural',
            lgdCode: '502430',
            gramPanchayat: 'Nadia GP',
            policeStationPostOffice: 'Nadia PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nadia North',
            lgdCode: '502431',
            gramPanchayat: 'Nadia Ward 1',
            policeStationPostOffice: 'Nadia PS / PO',
          ),
        ],
        'Nadia Block': [
          const VillageRecord(
            villageName: 'Nadia East',
            lgdCode: '502432',
            gramPanchayat: 'Nadia East GP',
            policeStationPostOffice: 'Nadia Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nadia South',
            lgdCode: '502433',
            gramPanchayat: 'Nadia South GP',
            policeStationPostOffice: 'Nadia Rural PS',
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
      'Paschim Bardhaman': {

        'Paschim Bardhaman City': [
          const VillageRecord(
            villageName: 'Paschim Bardhaman Rural',
            lgdCode: '502434',
            gramPanchayat: 'Paschim Bardhaman GP',
            policeStationPostOffice: 'Paschim Bardhaman PS / PO',
          ),
          const VillageRecord(
            villageName: 'Paschim Bardhaman North',
            lgdCode: '502435',
            gramPanchayat: 'Paschim Bardhaman Ward 1',
            policeStationPostOffice: 'Paschim Bardhaman PS / PO',
          ),
        ],
        'Paschim Bardhaman Block': [
          const VillageRecord(
            villageName: 'Paschim Bardhaman East',
            lgdCode: '502436',
            gramPanchayat: 'Paschim Bardhaman East GP',
            policeStationPostOffice: 'Paschim Bardhaman Rural PS',
          ),
          const VillageRecord(
            villageName: 'Paschim Bardhaman South',
            lgdCode: '502437',
            gramPanchayat: 'Paschim Bardhaman South GP',
            policeStationPostOffice: 'Paschim Bardhaman Rural PS',
          ),
        ],
      },
      'Paschim Medinipur': {

        'Paschim Medinipur City': [
          const VillageRecord(
            villageName: 'Paschim Medinipur Rural',
            lgdCode: '502438',
            gramPanchayat: 'Paschim Medinipur GP',
            policeStationPostOffice: 'Paschim Medinipur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Paschim Medinipur North',
            lgdCode: '502439',
            gramPanchayat: 'Paschim Medinipur Ward 1',
            policeStationPostOffice: 'Paschim Medinipur PS / PO',
          ),
        ],
        'Paschim Medinipur Block': [
          const VillageRecord(
            villageName: 'Paschim Medinipur East',
            lgdCode: '502440',
            gramPanchayat: 'Paschim Medinipur East GP',
            policeStationPostOffice: 'Paschim Medinipur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Paschim Medinipur South',
            lgdCode: '502441',
            gramPanchayat: 'Paschim Medinipur South GP',
            policeStationPostOffice: 'Paschim Medinipur Rural PS',
          ),
        ],
      },
      'Purba Bardhaman': {

        'Purba Bardhaman City': [
          const VillageRecord(
            villageName: 'Purba Bardhaman Rural',
            lgdCode: '502442',
            gramPanchayat: 'Purba Bardhaman GP',
            policeStationPostOffice: 'Purba Bardhaman PS / PO',
          ),
          const VillageRecord(
            villageName: 'Purba Bardhaman North',
            lgdCode: '502443',
            gramPanchayat: 'Purba Bardhaman Ward 1',
            policeStationPostOffice: 'Purba Bardhaman PS / PO',
          ),
        ],
        'Purba Bardhaman Block': [
          const VillageRecord(
            villageName: 'Purba Bardhaman East',
            lgdCode: '502444',
            gramPanchayat: 'Purba Bardhaman East GP',
            policeStationPostOffice: 'Purba Bardhaman Rural PS',
          ),
          const VillageRecord(
            villageName: 'Purba Bardhaman South',
            lgdCode: '502445',
            gramPanchayat: 'Purba Bardhaman South GP',
            policeStationPostOffice: 'Purba Bardhaman Rural PS',
          ),
        ],
      },
      'Purba Medinipur': {

        'Purba Medinipur City': [
          const VillageRecord(
            villageName: 'Purba Medinipur Rural',
            lgdCode: '502446',
            gramPanchayat: 'Purba Medinipur GP',
            policeStationPostOffice: 'Purba Medinipur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Purba Medinipur North',
            lgdCode: '502447',
            gramPanchayat: 'Purba Medinipur Ward 1',
            policeStationPostOffice: 'Purba Medinipur PS / PO',
          ),
        ],
        'Purba Medinipur Block': [
          const VillageRecord(
            villageName: 'Purba Medinipur East',
            lgdCode: '502448',
            gramPanchayat: 'Purba Medinipur East GP',
            policeStationPostOffice: 'Purba Medinipur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Purba Medinipur South',
            lgdCode: '502449',
            gramPanchayat: 'Purba Medinipur South GP',
            policeStationPostOffice: 'Purba Medinipur Rural PS',
          ),
        ],
      },
      'Purulia': {

        'Purulia City': [
          const VillageRecord(
            villageName: 'Purulia Rural',
            lgdCode: '502450',
            gramPanchayat: 'Purulia GP',
            policeStationPostOffice: 'Purulia PS / PO',
          ),
          const VillageRecord(
            villageName: 'Purulia North',
            lgdCode: '502451',
            gramPanchayat: 'Purulia Ward 1',
            policeStationPostOffice: 'Purulia PS / PO',
          ),
        ],
        'Purulia Block': [
          const VillageRecord(
            villageName: 'Purulia East',
            lgdCode: '502452',
            gramPanchayat: 'Purulia East GP',
            policeStationPostOffice: 'Purulia Rural PS',
          ),
          const VillageRecord(
            villageName: 'Purulia South',
            lgdCode: '502453',
            gramPanchayat: 'Purulia South GP',
            policeStationPostOffice: 'Purulia Rural PS',
          ),
        ],
      },
      'South 24 Parganas': {

        'South 24 Parganas City': [
          const VillageRecord(
            villageName: 'South 24 Parganas Rural',
            lgdCode: '502454',
            gramPanchayat: 'South 24 Parganas GP',
            policeStationPostOffice: 'South 24 Parganas PS / PO',
          ),
          const VillageRecord(
            villageName: 'South 24 Parganas North',
            lgdCode: '502455',
            gramPanchayat: 'South 24 Parganas Ward 1',
            policeStationPostOffice: 'South 24 Parganas PS / PO',
          ),
        ],
        'South 24 Parganas Block': [
          const VillageRecord(
            villageName: 'South 24 Parganas East',
            lgdCode: '502456',
            gramPanchayat: 'South 24 Parganas East GP',
            policeStationPostOffice: 'South 24 Parganas Rural PS',
          ),
          const VillageRecord(
            villageName: 'South 24 Parganas South',
            lgdCode: '502457',
            gramPanchayat: 'South 24 Parganas South GP',
            policeStationPostOffice: 'South 24 Parganas Rural PS',
          ),
        ],
      },
      'Uttar Dinajpur': {

        'Uttar Dinajpur City': [
          const VillageRecord(
            villageName: 'Uttar Dinajpur Rural',
            lgdCode: '502458',
            gramPanchayat: 'Uttar Dinajpur GP',
            policeStationPostOffice: 'Uttar Dinajpur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Uttar Dinajpur North',
            lgdCode: '502459',
            gramPanchayat: 'Uttar Dinajpur Ward 1',
            policeStationPostOffice: 'Uttar Dinajpur PS / PO',
          ),
        ],
        'Uttar Dinajpur Block': [
          const VillageRecord(
            villageName: 'Uttar Dinajpur East',
            lgdCode: '502460',
            gramPanchayat: 'Uttar Dinajpur East GP',
            policeStationPostOffice: 'Uttar Dinajpur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Uttar Dinajpur South',
            lgdCode: '502461',
            gramPanchayat: 'Uttar Dinajpur South GP',
            policeStationPostOffice: 'Uttar Dinajpur Rural PS',
          ),
        ],
      },
    },
    'Andaman and Nicobar Islands': {
      'Nicobar': {

        'Nicobar City': [
          const VillageRecord(
            villageName: 'Nicobar Rural',
            lgdCode: '502462',
            gramPanchayat: 'Nicobar GP',
            policeStationPostOffice: 'Nicobar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Nicobar North',
            lgdCode: '502463',
            gramPanchayat: 'Nicobar Ward 1',
            policeStationPostOffice: 'Nicobar PS / PO',
          ),
        ],
        'Nicobar Block': [
          const VillageRecord(
            villageName: 'Nicobar East',
            lgdCode: '502464',
            gramPanchayat: 'Nicobar East GP',
            policeStationPostOffice: 'Nicobar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Nicobar South',
            lgdCode: '502465',
            gramPanchayat: 'Nicobar South GP',
            policeStationPostOffice: 'Nicobar Rural PS',
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
    },
    'Delhi': {
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
      'East Delhi': {

        'East Delhi City': [
          const VillageRecord(
            villageName: 'East Delhi Rural',
            lgdCode: '502466',
            gramPanchayat: 'East Delhi GP',
            policeStationPostOffice: 'East Delhi PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Delhi North',
            lgdCode: '502467',
            gramPanchayat: 'East Delhi Ward 1',
            policeStationPostOffice: 'East Delhi PS / PO',
          ),
        ],
        'East Delhi Block': [
          const VillageRecord(
            villageName: 'East Delhi East',
            lgdCode: '502468',
            gramPanchayat: 'East Delhi East GP',
            policeStationPostOffice: 'East Delhi Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Delhi South',
            lgdCode: '502469',
            gramPanchayat: 'East Delhi South GP',
            policeStationPostOffice: 'East Delhi Rural PS',
          ),
        ],
      },
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
      'North East Delhi': {

        'East Delhi City': [
          const VillageRecord(
            villageName: 'East Delhi Rural',
            lgdCode: '502466',
            gramPanchayat: 'East Delhi GP',
            policeStationPostOffice: 'East Delhi PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Delhi North',
            lgdCode: '502467',
            gramPanchayat: 'East Delhi Ward 1',
            policeStationPostOffice: 'East Delhi PS / PO',
          ),
        ],
        'East Delhi Block': [
          const VillageRecord(
            villageName: 'East Delhi East',
            lgdCode: '502468',
            gramPanchayat: 'East Delhi East GP',
            policeStationPostOffice: 'East Delhi Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Delhi South',
            lgdCode: '502469',
            gramPanchayat: 'East Delhi South GP',
            policeStationPostOffice: 'East Delhi Rural PS',
          ),
        ],
      },
      'North West Delhi': {

        'North West Delhi City': [
          const VillageRecord(
            villageName: 'North West Delhi Rural',
            lgdCode: '502474',
            gramPanchayat: 'North West Delhi GP',
            policeStationPostOffice: 'North West Delhi PS / PO',
          ),
          const VillageRecord(
            villageName: 'North West Delhi North',
            lgdCode: '502475',
            gramPanchayat: 'North West Delhi Ward 1',
            policeStationPostOffice: 'North West Delhi PS / PO',
          ),
        ],
        'North West Delhi Block': [
          const VillageRecord(
            villageName: 'North West Delhi East',
            lgdCode: '502476',
            gramPanchayat: 'North West Delhi East GP',
            policeStationPostOffice: 'North West Delhi Rural PS',
          ),
          const VillageRecord(
            villageName: 'North West Delhi South',
            lgdCode: '502477',
            gramPanchayat: 'North West Delhi South GP',
            policeStationPostOffice: 'North West Delhi Rural PS',
          ),
        ],
      },
      'Shahdara': {

        'Shahdara City': [
          const VillageRecord(
            villageName: 'Shahdara Rural',
            lgdCode: '502478',
            gramPanchayat: 'Shahdara GP',
            policeStationPostOffice: 'Shahdara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shahdara North',
            lgdCode: '502479',
            gramPanchayat: 'Shahdara Ward 1',
            policeStationPostOffice: 'Shahdara PS / PO',
          ),
        ],
        'Shahdara Block': [
          const VillageRecord(
            villageName: 'Shahdara East',
            lgdCode: '502480',
            gramPanchayat: 'Shahdara East GP',
            policeStationPostOffice: 'Shahdara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shahdara South',
            lgdCode: '502481',
            gramPanchayat: 'Shahdara South GP',
            policeStationPostOffice: 'Shahdara Rural PS',
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
      'South East Delhi': {

        'East Delhi City': [
          const VillageRecord(
            villageName: 'East Delhi Rural',
            lgdCode: '502466',
            gramPanchayat: 'East Delhi GP',
            policeStationPostOffice: 'East Delhi PS / PO',
          ),
          const VillageRecord(
            villageName: 'East Delhi North',
            lgdCode: '502467',
            gramPanchayat: 'East Delhi Ward 1',
            policeStationPostOffice: 'East Delhi PS / PO',
          ),
        ],
        'East Delhi Block': [
          const VillageRecord(
            villageName: 'East Delhi East',
            lgdCode: '502468',
            gramPanchayat: 'East Delhi East GP',
            policeStationPostOffice: 'East Delhi Rural PS',
          ),
          const VillageRecord(
            villageName: 'East Delhi South',
            lgdCode: '502469',
            gramPanchayat: 'East Delhi South GP',
            policeStationPostOffice: 'East Delhi Rural PS',
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
      'West Delhi': {

        'North West Delhi City': [
          const VillageRecord(
            villageName: 'North West Delhi Rural',
            lgdCode: '502474',
            gramPanchayat: 'North West Delhi GP',
            policeStationPostOffice: 'North West Delhi PS / PO',
          ),
          const VillageRecord(
            villageName: 'North West Delhi North',
            lgdCode: '502475',
            gramPanchayat: 'North West Delhi Ward 1',
            policeStationPostOffice: 'North West Delhi PS / PO',
          ),
        ],
        'North West Delhi Block': [
          const VillageRecord(
            villageName: 'North West Delhi East',
            lgdCode: '502476',
            gramPanchayat: 'North West Delhi East GP',
            policeStationPostOffice: 'North West Delhi Rural PS',
          ),
          const VillageRecord(
            villageName: 'North West Delhi South',
            lgdCode: '502477',
            gramPanchayat: 'North West Delhi South GP',
            policeStationPostOffice: 'North West Delhi Rural PS',
          ),
        ],
      },
    },
    'Jammu and Kashmir': {
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
      'Bandipora': {

        'Bandipora City': [
          const VillageRecord(
            villageName: 'Bandipora Rural',
            lgdCode: '502486',
            gramPanchayat: 'Bandipora GP',
            policeStationPostOffice: 'Bandipora PS / PO',
          ),
          const VillageRecord(
            villageName: 'Bandipora North',
            lgdCode: '502487',
            gramPanchayat: 'Bandipora Ward 1',
            policeStationPostOffice: 'Bandipora PS / PO',
          ),
        ],
        'Bandipora Block': [
          const VillageRecord(
            villageName: 'Bandipora East',
            lgdCode: '502488',
            gramPanchayat: 'Bandipora East GP',
            policeStationPostOffice: 'Bandipora Rural PS',
          ),
          const VillageRecord(
            villageName: 'Bandipora South',
            lgdCode: '502489',
            gramPanchayat: 'Bandipora South GP',
            policeStationPostOffice: 'Bandipora Rural PS',
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
      'Budgam': {

        'Budgam City': [
          const VillageRecord(
            villageName: 'Budgam Rural',
            lgdCode: '502490',
            gramPanchayat: 'Budgam GP',
            policeStationPostOffice: 'Budgam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Budgam North',
            lgdCode: '502491',
            gramPanchayat: 'Budgam Ward 1',
            policeStationPostOffice: 'Budgam PS / PO',
          ),
        ],
        'Budgam Block': [
          const VillageRecord(
            villageName: 'Budgam East',
            lgdCode: '502492',
            gramPanchayat: 'Budgam East GP',
            policeStationPostOffice: 'Budgam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Budgam South',
            lgdCode: '502493',
            gramPanchayat: 'Budgam South GP',
            policeStationPostOffice: 'Budgam Rural PS',
          ),
        ],
      },
      'Doda': {

        'Doda City': [
          const VillageRecord(
            villageName: 'Doda Rural',
            lgdCode: '502494',
            gramPanchayat: 'Doda GP',
            policeStationPostOffice: 'Doda PS / PO',
          ),
          const VillageRecord(
            villageName: 'Doda North',
            lgdCode: '502495',
            gramPanchayat: 'Doda Ward 1',
            policeStationPostOffice: 'Doda PS / PO',
          ),
        ],
        'Doda Block': [
          const VillageRecord(
            villageName: 'Doda East',
            lgdCode: '502496',
            gramPanchayat: 'Doda East GP',
            policeStationPostOffice: 'Doda Rural PS',
          ),
          const VillageRecord(
            villageName: 'Doda South',
            lgdCode: '502497',
            gramPanchayat: 'Doda South GP',
            policeStationPostOffice: 'Doda Rural PS',
          ),
        ],
      },
      'Ganderbal': {

        'Ganderbal City': [
          const VillageRecord(
            villageName: 'Ganderbal Rural',
            lgdCode: '502498',
            gramPanchayat: 'Ganderbal GP',
            policeStationPostOffice: 'Ganderbal PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ganderbal North',
            lgdCode: '502499',
            gramPanchayat: 'Ganderbal Ward 1',
            policeStationPostOffice: 'Ganderbal PS / PO',
          ),
        ],
        'Ganderbal Block': [
          const VillageRecord(
            villageName: 'Ganderbal East',
            lgdCode: '502500',
            gramPanchayat: 'Ganderbal East GP',
            policeStationPostOffice: 'Ganderbal Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ganderbal South',
            lgdCode: '502501',
            gramPanchayat: 'Ganderbal South GP',
            policeStationPostOffice: 'Ganderbal Rural PS',
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
      'Kathua': {

        'Kathua City': [
          const VillageRecord(
            villageName: 'Kathua Rural',
            lgdCode: '502502',
            gramPanchayat: 'Kathua GP',
            policeStationPostOffice: 'Kathua PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kathua North',
            lgdCode: '502503',
            gramPanchayat: 'Kathua Ward 1',
            policeStationPostOffice: 'Kathua PS / PO',
          ),
        ],
        'Kathua Block': [
          const VillageRecord(
            villageName: 'Kathua East',
            lgdCode: '502504',
            gramPanchayat: 'Kathua East GP',
            policeStationPostOffice: 'Kathua Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kathua South',
            lgdCode: '502505',
            gramPanchayat: 'Kathua South GP',
            policeStationPostOffice: 'Kathua Rural PS',
          ),
        ],
      },
      'Kishtwar': {

        'Kishtwar City': [
          const VillageRecord(
            villageName: 'Kishtwar Rural',
            lgdCode: '502506',
            gramPanchayat: 'Kishtwar GP',
            policeStationPostOffice: 'Kishtwar PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kishtwar North',
            lgdCode: '502507',
            gramPanchayat: 'Kishtwar Ward 1',
            policeStationPostOffice: 'Kishtwar PS / PO',
          ),
        ],
        'Kishtwar Block': [
          const VillageRecord(
            villageName: 'Kishtwar East',
            lgdCode: '502508',
            gramPanchayat: 'Kishtwar East GP',
            policeStationPostOffice: 'Kishtwar Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kishtwar South',
            lgdCode: '502509',
            gramPanchayat: 'Kishtwar South GP',
            policeStationPostOffice: 'Kishtwar Rural PS',
          ),
        ],
      },
      'Kulgam': {

        'Kulgam City': [
          const VillageRecord(
            villageName: 'Kulgam Rural',
            lgdCode: '502510',
            gramPanchayat: 'Kulgam GP',
            policeStationPostOffice: 'Kulgam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kulgam North',
            lgdCode: '502511',
            gramPanchayat: 'Kulgam Ward 1',
            policeStationPostOffice: 'Kulgam PS / PO',
          ),
        ],
        'Kulgam Block': [
          const VillageRecord(
            villageName: 'Kulgam East',
            lgdCode: '502512',
            gramPanchayat: 'Kulgam East GP',
            policeStationPostOffice: 'Kulgam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kulgam South',
            lgdCode: '502513',
            gramPanchayat: 'Kulgam South GP',
            policeStationPostOffice: 'Kulgam Rural PS',
          ),
        ],
      },
      'Kupwara': {

        'Kupwara City': [
          const VillageRecord(
            villageName: 'Kupwara Rural',
            lgdCode: '502514',
            gramPanchayat: 'Kupwara GP',
            policeStationPostOffice: 'Kupwara PS / PO',
          ),
          const VillageRecord(
            villageName: 'Kupwara North',
            lgdCode: '502515',
            gramPanchayat: 'Kupwara Ward 1',
            policeStationPostOffice: 'Kupwara PS / PO',
          ),
        ],
        'Kupwara Block': [
          const VillageRecord(
            villageName: 'Kupwara East',
            lgdCode: '502516',
            gramPanchayat: 'Kupwara East GP',
            policeStationPostOffice: 'Kupwara Rural PS',
          ),
          const VillageRecord(
            villageName: 'Kupwara South',
            lgdCode: '502517',
            gramPanchayat: 'Kupwara South GP',
            policeStationPostOffice: 'Kupwara Rural PS',
          ),
        ],
      },
      'Poonch': {

        'Poonch City': [
          const VillageRecord(
            villageName: 'Poonch Rural',
            lgdCode: '502518',
            gramPanchayat: 'Poonch GP',
            policeStationPostOffice: 'Poonch PS / PO',
          ),
          const VillageRecord(
            villageName: 'Poonch North',
            lgdCode: '502519',
            gramPanchayat: 'Poonch Ward 1',
            policeStationPostOffice: 'Poonch PS / PO',
          ),
        ],
        'Poonch Block': [
          const VillageRecord(
            villageName: 'Poonch East',
            lgdCode: '502520',
            gramPanchayat: 'Poonch East GP',
            policeStationPostOffice: 'Poonch Rural PS',
          ),
          const VillageRecord(
            villageName: 'Poonch South',
            lgdCode: '502521',
            gramPanchayat: 'Poonch South GP',
            policeStationPostOffice: 'Poonch Rural PS',
          ),
        ],
      },
      'Pulwama': {

        'Pulwama City': [
          const VillageRecord(
            villageName: 'Pulwama Rural',
            lgdCode: '502522',
            gramPanchayat: 'Pulwama GP',
            policeStationPostOffice: 'Pulwama PS / PO',
          ),
          const VillageRecord(
            villageName: 'Pulwama North',
            lgdCode: '502523',
            gramPanchayat: 'Pulwama Ward 1',
            policeStationPostOffice: 'Pulwama PS / PO',
          ),
        ],
        'Pulwama Block': [
          const VillageRecord(
            villageName: 'Pulwama East',
            lgdCode: '502524',
            gramPanchayat: 'Pulwama East GP',
            policeStationPostOffice: 'Pulwama Rural PS',
          ),
          const VillageRecord(
            villageName: 'Pulwama South',
            lgdCode: '502525',
            gramPanchayat: 'Pulwama South GP',
            policeStationPostOffice: 'Pulwama Rural PS',
          ),
        ],
      },
      'Rajouri': {

        'Rajouri City': [
          const VillageRecord(
            villageName: 'Rajouri Rural',
            lgdCode: '502526',
            gramPanchayat: 'Rajouri GP',
            policeStationPostOffice: 'Rajouri PS / PO',
          ),
          const VillageRecord(
            villageName: 'Rajouri North',
            lgdCode: '502527',
            gramPanchayat: 'Rajouri Ward 1',
            policeStationPostOffice: 'Rajouri PS / PO',
          ),
        ],
        'Rajouri Block': [
          const VillageRecord(
            villageName: 'Rajouri East',
            lgdCode: '502528',
            gramPanchayat: 'Rajouri East GP',
            policeStationPostOffice: 'Rajouri Rural PS',
          ),
          const VillageRecord(
            villageName: 'Rajouri South',
            lgdCode: '502529',
            gramPanchayat: 'Rajouri South GP',
            policeStationPostOffice: 'Rajouri Rural PS',
          ),
        ],
      },
      'Ramban': {

        'Ramban City': [
          const VillageRecord(
            villageName: 'Ramban Rural',
            lgdCode: '502530',
            gramPanchayat: 'Ramban GP',
            policeStationPostOffice: 'Ramban PS / PO',
          ),
          const VillageRecord(
            villageName: 'Ramban North',
            lgdCode: '502531',
            gramPanchayat: 'Ramban Ward 1',
            policeStationPostOffice: 'Ramban PS / PO',
          ),
        ],
        'Ramban Block': [
          const VillageRecord(
            villageName: 'Ramban East',
            lgdCode: '502532',
            gramPanchayat: 'Ramban East GP',
            policeStationPostOffice: 'Ramban Rural PS',
          ),
          const VillageRecord(
            villageName: 'Ramban South',
            lgdCode: '502533',
            gramPanchayat: 'Ramban South GP',
            policeStationPostOffice: 'Ramban Rural PS',
          ),
        ],
      },
      'Reasi': {

        'Reasi City': [
          const VillageRecord(
            villageName: 'Reasi Rural',
            lgdCode: '502534',
            gramPanchayat: 'Reasi GP',
            policeStationPostOffice: 'Reasi PS / PO',
          ),
          const VillageRecord(
            villageName: 'Reasi North',
            lgdCode: '502535',
            gramPanchayat: 'Reasi Ward 1',
            policeStationPostOffice: 'Reasi PS / PO',
          ),
        ],
        'Reasi Block': [
          const VillageRecord(
            villageName: 'Reasi East',
            lgdCode: '502536',
            gramPanchayat: 'Reasi East GP',
            policeStationPostOffice: 'Reasi Rural PS',
          ),
          const VillageRecord(
            villageName: 'Reasi South',
            lgdCode: '502537',
            gramPanchayat: 'Reasi South GP',
            policeStationPostOffice: 'Reasi Rural PS',
          ),
        ],
      },
      'Samba': {

        'Samba City': [
          const VillageRecord(
            villageName: 'Samba Rural',
            lgdCode: '502538',
            gramPanchayat: 'Samba GP',
            policeStationPostOffice: 'Samba PS / PO',
          ),
          const VillageRecord(
            villageName: 'Samba North',
            lgdCode: '502539',
            gramPanchayat: 'Samba Ward 1',
            policeStationPostOffice: 'Samba PS / PO',
          ),
        ],
        'Samba Block': [
          const VillageRecord(
            villageName: 'Samba East',
            lgdCode: '502540',
            gramPanchayat: 'Samba East GP',
            policeStationPostOffice: 'Samba Rural PS',
          ),
          const VillageRecord(
            villageName: 'Samba South',
            lgdCode: '502541',
            gramPanchayat: 'Samba South GP',
            policeStationPostOffice: 'Samba Rural PS',
          ),
        ],
      },
      'Shopian': {

        'Shopian City': [
          const VillageRecord(
            villageName: 'Shopian Rural',
            lgdCode: '502542',
            gramPanchayat: 'Shopian GP',
            policeStationPostOffice: 'Shopian PS / PO',
          ),
          const VillageRecord(
            villageName: 'Shopian North',
            lgdCode: '502543',
            gramPanchayat: 'Shopian Ward 1',
            policeStationPostOffice: 'Shopian PS / PO',
          ),
        ],
        'Shopian Block': [
          const VillageRecord(
            villageName: 'Shopian East',
            lgdCode: '502544',
            gramPanchayat: 'Shopian East GP',
            policeStationPostOffice: 'Shopian Rural PS',
          ),
          const VillageRecord(
            villageName: 'Shopian South',
            lgdCode: '502545',
            gramPanchayat: 'Shopian South GP',
            policeStationPostOffice: 'Shopian Rural PS',
          ),
        ],
      },
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
      'Udhampur': {

        'Udhampur City': [
          const VillageRecord(
            villageName: 'Udhampur Rural',
            lgdCode: '502546',
            gramPanchayat: 'Udhampur GP',
            policeStationPostOffice: 'Udhampur PS / PO',
          ),
          const VillageRecord(
            villageName: 'Udhampur North',
            lgdCode: '502547',
            gramPanchayat: 'Udhampur Ward 1',
            policeStationPostOffice: 'Udhampur PS / PO',
          ),
        ],
        'Udhampur Block': [
          const VillageRecord(
            villageName: 'Udhampur East',
            lgdCode: '502548',
            gramPanchayat: 'Udhampur East GP',
            policeStationPostOffice: 'Udhampur Rural PS',
          ),
          const VillageRecord(
            villageName: 'Udhampur South',
            lgdCode: '502549',
            gramPanchayat: 'Udhampur South GP',
            policeStationPostOffice: 'Udhampur Rural PS',
          ),
        ],
      },
    },
    'Ladakh': {
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
      'Mahe': {

        'Mahe City': [
          const VillageRecord(
            villageName: 'Mahe Rural',
            lgdCode: '502550',
            gramPanchayat: 'Mahe GP',
            policeStationPostOffice: 'Mahe PS / PO',
          ),
          const VillageRecord(
            villageName: 'Mahe North',
            lgdCode: '502551',
            gramPanchayat: 'Mahe Ward 1',
            policeStationPostOffice: 'Mahe PS / PO',
          ),
        ],
        'Mahe Block': [
          const VillageRecord(
            villageName: 'Mahe East',
            lgdCode: '502552',
            gramPanchayat: 'Mahe East GP',
            policeStationPostOffice: 'Mahe Rural PS',
          ),
          const VillageRecord(
            villageName: 'Mahe South',
            lgdCode: '502553',
            gramPanchayat: 'Mahe South GP',
            policeStationPostOffice: 'Mahe Rural PS',
          ),
        ],
      },
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
      'Yanam': {

        'Yanam City': [
          const VillageRecord(
            villageName: 'Yanam Rural',
            lgdCode: '502554',
            gramPanchayat: 'Yanam GP',
            policeStationPostOffice: 'Yanam PS / PO',
          ),
          const VillageRecord(
            villageName: 'Yanam North',
            lgdCode: '502555',
            gramPanchayat: 'Yanam Ward 1',
            policeStationPostOffice: 'Yanam PS / PO',
          ),
        ],
        'Yanam Block': [
          const VillageRecord(
            villageName: 'Yanam East',
            lgdCode: '502556',
            gramPanchayat: 'Yanam East GP',
            policeStationPostOffice: 'Yanam Rural PS',
          ),
          const VillageRecord(
            villageName: 'Yanam South',
            lgdCode: '502557',
            gramPanchayat: 'Yanam South GP',
            policeStationPostOffice: 'Yanam Rural PS',
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
