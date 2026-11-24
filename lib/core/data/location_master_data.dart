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
  // Master hierarchy: State -> District -> Block -> List<VillageRecord>
  static final Map<String, Map<String, Map<String, List<VillageRecord>>>> hierarchy = {
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
      },
    },
    'Arunachal Pradesh': {
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
        ],
      },
    },
  };

  static List<String> getStates() {
    return hierarchy.keys.toList()..sort();
  }

  static List<String> getDistricts(String state) {
    if (!hierarchy.containsKey(state)) return [];
    return hierarchy[state]!.keys.toList()..sort();
  }

  static List<String> getBlocks(String state, String district) {
    if (!hierarchy.containsKey(state)) return [];
    final districts = hierarchy[state]!;
    if (!districts.containsKey(district)) return [];
    return districts[district]!.keys.toList()..sort();
  }

  static List<VillageRecord> getVillages(String state, String district, String block) {
    if (!hierarchy.containsKey(state)) return [];
    final districts = hierarchy[state]!;
    if (!districts.containsKey(district)) return [];
    final blocks = districts[district]!;
    if (!blocks.containsKey(block)) return [];
    return blocks[block]!;
  }

  static VillageRecord? findVillage(String state, String district, String block, String villageName) {
    final list = getVillages(state, district, block);
    for (final v in list) {
      if (v.villageName.toLowerCase() == villageName.toLowerCase()) {
        return v;
      }
    }
    return null;
  }
}
