require_relative "xml_view_test_helper"

expected_summary =
  'The objective and intention of the inspection and this report is to provide the client/end user with information relating to the installed Air Conditioning/Comfort Cooling systems (AC) and Ventilation Systems and endeavour to provide ideas and recommendations for the site to reduce its CO2 emissions, lower energy consumption and save money on energy bills.

        BUILDING TYPE/DETAILS:

        The site inspected was; A Shop located in London. The site was inspected on the 20th May 2019. The estimated total floor area provided with air conditioning/comfort cooling (AC) on site was circa; 1876m2.

      '

describe ViewModel::AcReportWrapper do
  context "Testing the AC-REPORT schemas" do
    supported_schema = [
      {
        schema_name: "CEPC-8.0.0",
        xml: Samples.xml("CEPC-8.0.0", "ac-report"),
        unsupported_fields: [],
        different_fields: { related_rrn: nil },
      },
      {
        schema_name: "CEPC-NI-8.0.0",
        xml: Samples.xml("CEPC-NI-8.0.0", "ac-report"),
        unsupported_fields: [],
        different_fields: {},
        different_buried_fields: {
          address: {
            address_id: "RRN-0000-0000-0000-0000-0000",
          },
        },
      },
      {
        schema_name: "CEPC-7.1",
        xml: Samples.xml("CEPC-7.1", "ac-report"),
        unsupported_fields: [],
        different_fields: {},
        different_buried_fields: {
          address: {
            address_id: "LPRN-432167890000",
          },
        },
      },
      {
        schema_name: "CEPC-7.0",
        xml: Samples.xml("CEPC-7.0", "ac-report"),
        unsupported_fields: [],
        different_fields: {},
        different_buried_fields: {
          address: {
            address_id: "LPRN-432167890000",
          },
        },
      },
      {
        schema_name: "CEPC-6.0",
        xml: Samples.xml("CEPC-6.0", "ac-report"),
        unsupported_fields: [],
        different_fields: {
          related_party_disclosure: "No related Party",
          sub_systems: [],
          pre_inspection_checklist: {
            pcs: {
              essential: {
                list_of_systems: false,
                temperature_control_method: false,
                operation_control_method: false,
              },
              desirable: {
                previous_reports: false,
                maintenance_records: false,
                calibration_records: false,
                consumption_records: false,
              },
              optional: {
                cooling_load_estimate: false, complaint_records: false
              },
            },
            sccs: {
              essential: {
                list_of_systems: true,
                cooling_capacities: true,
                control_zones: true,
                temperature_controls: true,
                operation_controls: true,
                schematics: false,
              },
              desirable: {
                previous_reports: true,
                refrigeration_maintenance: false,
                delivery_system_maintenance: true,
                control_system_maintenance: true,
                consumption_records: true,
                commissioning_results: true,
              },
              optional: {
                cooling_load_estimate: true,
                complaint_records: true,
                bms_capability: true,
                monitoring_capability: true,
              },
            },
          },
          cooling_plants: [],
          air_handling_systems: [],
          terminal_units: [],
          system_controls: [],
        },
        different_buried_fields: {
          address: {
            address_id: "LPRN-432167890000",
          },
        },
      },
      {
        schema_name: "CEPC-5.0",
        xml: Samples.xml("CEPC-5.0", "ac-report"),
        unsupported_fields: [],
        different_fields: {
          related_party_disclosure: "No related Party",
          sub_systems: [],
          pre_inspection_checklist: {
            pcs: {
              essential: {
                list_of_systems: false,
                temperature_control_method: false,
                operation_control_method: false,
              },
              desirable: {
                previous_reports: false,
                maintenance_records: false,
                calibration_records: false,
                consumption_records: false,
              },
              optional: {
                cooling_load_estimate: false, complaint_records: false
              },
            },
            sccs: {
              essential: {
                list_of_systems: true,
                cooling_capacities: true,
                control_zones: true,
                temperature_controls: true,
                operation_controls: true,
                schematics: false,
              },
              desirable: {
                previous_reports: true,
                refrigeration_maintenance: false,
                delivery_system_maintenance: true,
                control_system_maintenance: true,
                consumption_records: true,
                commissioning_results: true,
              },
              optional: {
                cooling_load_estimate: true,
                complaint_records: true,
                bms_capability: true,
                monitoring_capability: true,
              },
            },
          },
          cooling_plants: [],
          air_handling_systems: [],
          terminal_units: [],
          system_controls: [],
        },
        different_buried_fields: {
          address: {
            address_id: "LPRN-432167890000",
          },
        },
      },
      {
        schema_name: "CEPC-4.0",
        xml: Samples.xml("CEPC-4.0", "ac-report"),
        unsupported_fields: [],
        different_fields: {
          related_party_disclosure: "No related Party",
          sub_systems: [],
          pre_inspection_checklist: {
            pcs: {
              essential: {
                list_of_systems: false,
                temperature_control_method: false,
                operation_control_method: false,
              },
              desirable: {
                previous_reports: false,
                maintenance_records: false,
                calibration_records: false,
                consumption_records: false,
              },
              optional: {
                cooling_load_estimate: false, complaint_records: false
              },
            },
            sccs: {
              essential: {
                list_of_systems: true,
                cooling_capacities: true,
                control_zones: true,
                temperature_controls: true,
                operation_controls: true,
                schematics: false,
              },
              desirable: {
                previous_reports: true,
                refrigeration_maintenance: false,
                delivery_system_maintenance: true,
                control_system_maintenance: true,
                consumption_records: true,
                commissioning_results: true,
              },
              optional: {
                cooling_load_estimate: true,
                complaint_records: true,
                bms_capability: true,
                monitoring_capability: true,
              },
            },
          },
          cooling_plants: [],
          air_handling_systems: [],
          terminal_units: [],
          system_controls: [],
        },
        different_buried_fields: {
          address: {
            address_id: "LPRN-432167890000",
          },
        },
      },
    ].freeze

    asserted_keys = {
      assessment_id: "0000-0000-0000-0000-0000",
      report_type: "5",
      type_of_assessment: "AC-REPORT",
      date_of_expiry: "2030-05-04",
      date_of_registration: "2020-05-20",
      address: {
        address_id: "UPRN-432167890000",
        address_line1: "2 Lonely Street",
        address_line2: nil,
        address_line3: nil,
        address_line4: nil,
        town: "Post-Town1",
        postcode: "A0 0AA",
      },
      related_party_disclosure: "1",
      assessor: {
        scheme_assessor_id: "SPEC000000",
        name: "Test Assessor Name",
        contact_details: {
          email: "test@example.com", telephone: "07555 666777"
        },
        company_details: {
          name: "Assess Energy Limited",
          address: "111 Twotwotwo Street, Mytown,, MT7 1AA",
        },
      },
      related_rrn: "0000-0000-0000-0000-0001",
      executive_summary: expected_summary,
      key_recommendations: {
        efficiency: [
          { sequence: "0", text: "A way to improve your efficiency" },
          { sequence: "1", text: "A second way to improve efficiency" },
        ],
        maintenance: [{ sequence: "0", text: "Text2" }],
        control: [{ sequence: "0", text: "Text4" }],
        management: [{ sequence: "0", text: "Text6" }],
      },
      sub_systems: [
        volume_definitions: "VOL001 The Shop",
        id: "VOL001/SYS001 R410A Inverter Split Systems to Sales Area",
        description:
          "This sub system comprised of; 4Nr 10kW R410A Mitsubishi Heavy Industries inverter driven split AC condensers.",
        cooling_output: "40",
        area_served: "Sales Area",
        inspection_date: "2019-05-20",
        cooling_plant_count: "4",
        ahu_count: "0",
        terminal_units_count: "4",
        controls_count: "5",
      ],
      pre_inspection_checklist: {
        essential: {
          control_zones: false,
          cooling_capacities: false,
          list_of_systems: true,
          operation_controls: false,
          schematics: false,
          temperature_controls: false,
        },
        desirable: {
          commissioning_results: false,
          consumption_records: false,
          control_system_maintenance: false,
          delivery_system_maintenance: false,
          previous_reports: false,
          refrigeration_maintenance: false,
        },
        optional: {
          bms_capability: false,
          complaint_records: false,
          cooling_load_estimate: false,
          monitoring_capability: false,
        },
      },
      cooling_plants: [
        {
          system_number:
            "VOL001/SYS001 R410A Inverter Split Systems to Sales Area",
          identifier: "VOL001/SYS001/CP1 Sampled R410A Inverter Split Area (1)",
          equipment: {
            cooling_capacity: "10",
            description: "Single Split",
            location: "Externally on roof",
            manufacturer: "Mitsubishi",
            model_reference: "FDC100VN",
            refrigerant_charge: "3",
            refrigerant_type: {
              ecfgasregulation: nil, ecozoneregulation: nil, type: "R410A"
            },
            serial_number: "not visible",
            year_installed: "2014",
            area_served: "Sales Area",
            discrepancy_note:
              "Brief details of the installed equipment onsite were provided prior to the inspection however a full and comprehensive asset schedule was not available; it should be considered to prepare a full and comprehensive asset schedule for the site. This should include: system identification/reference numbers to enable determination of which condensers serve which indoor units and detail system model numbers, serial numbers, kW capacities, refrigerant charge, etc for each system. No discrepancy noted between information provided and site observations.",
          },
          inspection: {
            air_recirculation: {
              note: "The condenser was considered suitably located.",
              state: true,
              guidance: "No recommendation required.",
            },
            chiller_placement_ok: {
              note: "The condenser is considered suitably located.",
              state: true,
              guidance: "No recommendation required.",
            },
            chiller_plant_area_clear: {
              note: "Area appeared clear and satisfactory.",
              state: true,
              guidance: "No recommendation required.",
            },
            chiller_plant_ok: {
              note: "General condition of the plant appeared satisfactory.",
              state: true,
              guidance:
                "Ensure the system is regularly maintained to extend the useful life of the equipment.",
            },
            chiller_plant_operational: {
              note: "System appeared to operate satisfactorily.",
              state: true,
              guidance:
                "Ensure the system is regularly maintained to extend the useful life of the equipment.",
            },
            compressors_operational: {
              note:
                "The compressor appeared to operate satisfactorily with the air off temperatures as expected.",
              state: true,
              guidance:
                "No recommendation required other than ensuring the system refrigerant charge is checked in accordance with manufacturers recommendations to ensure the unit continues to operate satisfactorily.",
            },
            heat_exchanger_ok: {
              note: "Heat exchangers appeared satisfactory and clean.",
              state: true,
              guidance:
                "No recommendation required other than recommending maintenance regime continues.",
            },
            heat_rejection_area_clear: {
              note: "The area was clear and appeared satisfactory.",
              state: true,
              guidance: "No recommendation required.",
            },
            heat_rejection_operational: {
              note: "Heat rejection plant appeared to operate as expected.",
              state: true,
              guidance: "Not recommendation required.",
            },
            pipe_insulation_ok: {
              note:
                "Thermal insulation appeared in good order and well fitted.",
              state: true,
              guidance: "No recommendation required.",
            },
          },
          sizing: {
            acceptable_installed_size: "1",
            guidance: [
              {
                code: "OTHER",
                seq_number: "1",
                text:
                  "This occupancy is based on information obtained from site",
              },
              {
                code: "OTHER",
                seq_number: "2",
                text:
                  "No recommendation required; occupancy level appears appropriate.",
              },
              {
                code: "OTHER",
                seq_number: "3",
                text: "Floor area was measured whilst on site.",
              },
              {
                code: "OTHER",
                seq_number: "4",
                text: "No recommendation required.",
              },
            ],
            installed_capacity: "10.0",
            occupant_density: "8.93",
            total_floor_area: "357",
            total_occupants: "40",
            upper_heat_gain: "140.0",
          },
          refrigeration: {
            acceptable_temperature: "0",
            ambient: "13",
            compressor_control: { note: "The capacity control is inverter." },
            f_gas_inspection: {
              note:
                "The system operated using refrigerant which is not banned.",
              state: true,
            },
            guidance: [
              {
                code: "OTHER",
                seq_number: "1",
                text:
                  "Access to the pre and post compressor for this type of system is difficult with a visual inspection; therefore the air on/room temperature and air off temperatures were taken from the indoor unit. (Pre Compressor temperature detailed is therefore the room temperature).",
              },
              {
                code: "OTHER",
                seq_number: "2",
                text: "No recommendation required.",
              },
            ],
            post_processor: "7",
            pre_compressor: "22",
            refrigerant_leak: {
              note:
                "There were no visible signs of a leak observed during the inspection.",
              state: false,
            },
            refrigerant_name: "R410A",
          },
          maintenance: {
            competent_person: {
              note:
                "Maintenance contract advised as being in place and would appear satisfactory due to unit condition.",
              state: true,
            },
            guidance: nil,
            records_kept: {
              note: "Yes system appears in good order for age.", state: true
            },
          },
          metering: {
            bem_installed: {
              note: "The system is linked to a Central Controller.", state: true
            },
            excessive_use: { note: "No details available.", state: false },
            metering_installed: { note: "", state: false },
            usage_records: {
              note:
                "There were no records of air conditioning plant usage or sub-metered energy consumption with expected hours of use per year for the plant or systems located on site.",
              state: false,
            },
          },
          humidity_control: {
            note: "N/A no humidity control installed to this system",
            state: false,
          },
          chillers: {
            water_cooled: {
              note: "N/A no cooling towers installed to this system",
              state: false,
            },
            water_treatment: {
              note: "N/A no cooling towers installed to this site", state: false
            },
          },
        },
        {
          system_number:
            "VOL001/SYS001 R410A Inverter Split Systems to Sales Area",
          identifier: "VOL001/SYS001/CP2 Sampled R410A Inverter Split Area (2)",
          equipment: {
            cooling_capacity: "10",
            description: "Single Split",
            location: "Externally on roof",
            manufacturer: "Mitsubishi",
            model_reference: "FDC100VN",
            refrigerant_charge: "3",
            refrigerant_type: {
              ecfgasregulation: nil, ecozoneregulation: nil, type: "R410A"
            },
            serial_number: "not visible",
            year_installed: "2014",
            area_served: "",
            discrepancy_note:
              "No discrepancy noted between information provided and site observations.",
          },
          inspection: {
            air_recirculation: {
              note: "The condenser was considered suitably located.",
              state: true,
              guidance: "No recommendation required.",
            },
            chiller_placement_ok: {
              note: "The condenser is considered suitably located.",
              state: true,
              guidance: "No recommendation required.",
            },
            chiller_plant_area_clear: {
              note: "Area appeared clear and satisfactory.",
              state: true,
              guidance: "No recommendation required.",
            },
            chiller_plant_ok: {
              note: "General condition of the plant appeared satisfactory.",
              state: true,
              guidance:
                "Ensure the system is regularly maintained to extend the useful life of the equipment.",
            },
            chiller_plant_operational: {
              note: "System appeared to operate satisfactorily.",
              state: true,
              guidance:
                "Ensure the system is regularly maintained to extend the useful life of the equipment.",
            },
            compressors_operational: {
              note:
                "The compressor appeared to operate satisfactorily with the air off temperatures as expected.",
              state: true,
              guidance: "No recommendation required.",
            },
            heat_exchanger_ok: {
              note: "Heat exchangers appeared satisfactory and clean.",
              state: true,
              guidance:
                "No recommendation required other than recommending maintenance regime continues.",
            },
            heat_rejection_area_clear: {
              note: "The area was clear and appeared satisfactory.",
              state: true,
              guidance: "No recommendation required.",
            },
            heat_rejection_operational: {
              note: "Heat rejection plant appeared to operate as expected.",
              guidance: "No recommendation required.",
              state: true,
            },
            pipe_insulation_ok: {
              note:
                "Thermal insulation appeared in good order and well fitted.",
              guidance: "No recommendation required.",
              state: true,
            },
          },
          sizing: {
            acceptable_installed_size: "1",
            guidance: [
              {
                code: "OTHER",
                seq_number: "1",
                text:
                  "This occupancy is based on information obtained from site",
              },
              {
                code: "OTHER",
                seq_number: "2",
                text:
                  "No recommendation required; occupancy level appears appropriate.",
              },
            ],
            installed_capacity: "10.0",
            occupant_density: "8.93",
            total_floor_area: "357",
            total_occupants: "40",
            upper_heat_gain: "140.0",
          },
          refrigeration: {
            acceptable_temperature: "0",
            ambient: "13",
            compressor_control: { note: "The capacity control is inverter." },
            f_gas_inspection: {
              note:
                "The system operated using refrigerant which is not banned.",
              state: true,
            },
            guidance: [
              {
                code: "OTHER",
                seq_number: "1",
                text:
                  "Access to the pre and post compressor for this type of system is difficult with a visual inspection.",
              },
              {
                code: "OTHER",
                seq_number: "2",
                text: "No recommendation required.",
              },
            ],
            post_processor: "8",
            pre_compressor: "22",
            refrigerant_leak: {
              note:
                "There were no visible signs of a leak observed during the inspection.",
              state: false,
            },
            refrigerant_name: "R410A",
          },
          maintenance: {
            competent_person: {
              note:
                "Maintenance contract advised as being in place and would appear satisfactory due to unit condition.",
              state: true,
            },
            guidance: nil,
            records_kept: {
              note: "Yes system appears in good order for age.", state: true
            },
          },
          metering: {
            bem_installed: {
              note: "The system is linked to a Central Controller.", state: true
            },
            excessive_use: { note: "No details available.", state: false },
            metering_installed: { note: "", state: false },
            usage_records: {
              note:
                "There were no records of air conditioning plant usage or sub-metered energy consumption with expected hours of use per year for the plant or systems located on site.",
              state: false,
            },
          },
          humidity_control: {
            note: "N/A no humidity control installed to this system",
            state: false,
          },
          chillers: {
            water_cooled: {
              note: "N/A no cooling towers installed to this system",
              state: false,
            },
            water_treatment: {
              note: "N/A no cooling towers installed to this site", state: false
            },
          },
        },
      ],
      air_handling_systems: [
        {
          equipment: {
            areas_served: "Corridor",
            component: "VENT1 Heat recovery",
            discrepancy: "None",
            location: "Above corridor ceiling",
            manufacturer: "NUAIRE",
            systems_served: "Corridor",
            unit: "123",
            year_installed: "2016",
          },
          inspection: {
            filters: {
              filter_condition: {
                flag: true,
                note: "Quite good condition",
                recommendations: [
                  { sequence: "0", text: "Give it a good scrub" },
                ],
              },
              change_frequency: { flag: false, note: nil, recommendations: [] },
              differential_pressure_gauge: {
                flag: false, note: nil, recommendations: []
              },
            },
            heat_exchangers: {
              condition: { flag: true, note: nil, recommendations: [] },
            },
            refrigeration: {
              leaks: { flag: true, note: nil, recommendations: [] },
            },
            fan_rotation: {
              direction: { flag: true, note: nil, recommendations: [] },
              modulation: { flag: true, note: nil, recommendations: [] },
            },
            air_leakage: {
              condition: { note: "No leaks", recommendations: [] },
            },
            heat_recovery: {
              energy_conservation: { note: "None", recommendations: [] },
            },
            outdoor_inlets: {
              condition: { note: "Diffusers clean", recommendations: [] },
            },
            fan_control: {
              setting: { note: "No dampers", recommendations: [] },
            },
            fan_power: {
              condition: { note: nil, flag: true, recommendations: [] },
              sfp_calculation: "464 watts x 70% - 0.311/400 = 8.12 w/ltr.",
            },
          },
        },
      ],
      terminal_units: [
        {
          equipment: {
            unit: "VOL1/SYS1",
            component:
              "Indoor wall type split which is part of a multi system with 5 indoor units.",
            description: "VOL1/SYS1/a",
            cooling_plant: "Cooling system",
            manufacturer: "Mitsubishi Electric",
            year_installed: "2011",
            area_served: "ICT Suite",
            discrepancy: "None",
          },
          inspection: {
            insulation: {
              pipework: { note: nil, recommendations: [], flag: true },
              ductwork: { note: nil, recommendations: [], flag: false },
            },
            unit: { condition: { note: nil, recommendations: [], flag: true } },
            grilles_air_flow: {
              distribution: { note: nil, recommendations: [], flag: true },
              tampering: { note: nil, recommendations: [], flag: true },
              water_supply: { note: nil, recommendations: [], flag: false },
              complaints: { note: nil, recommendations: [], flag: false },
            },
            diffuser_positions: {
              position_issues: { note: nil, recommendations: [], flag: true },
              partitioning_issues: {
                note: nil, recommendations: [], flag: false
              },
              control_operation: { note: nil, recommendations: [], flag: true },
            },
          },
        },
      ],
      system_controls: [
        {
          sub_system_id:
            "VOL001/SYS001 R410A Inverter Split Systems to Sales Area",
          component:
            "VOL001/SYS001/SC1 AC Local Controller to Sales Area Unit 1",
          inspection: {
            zoning: {
              note:
                "Local Controller\n\n            Zoning is considered satisfactory as systems are linked to single controller.",
              recommendations: [
                {
                  sequence: "1",
                  text:
                    "Where an area/room has more than one AC system installed that have separate controllers; it should be ensured that AC systems are set to the same set point temperature and mode (heating/cooling/auto).",
                },
              ],
              flag: true,
            },
            time: {
              note:
                "Time/date on the local controller is not used as Central controller timeclock controls the units.",
              recommendations: [
                { sequence: "1", text: "No recommendation required." },
              ],
            },
            set_on_period: {
              note: "N/A Central controller timeclock controls the units.",
              recommendations: [
                { sequence: "1", text: "No recommendation required" },
              ],
            },
            timer_shortfall: {
              note: "There is no shortfall in controller capabilities.",
              recommendations: [
                { sequence: "1", text: "No recommendation required." },
              ],
              flag: false,
            },
            sensors: {
              note: "Sensors are considered satisfactory.",
              recommendations: [
                { sequence: "1", text: "No recommendation required." },
              ],
              flag: true,
            },
            set_temperature: {
              note: "The set temperature on local controller; 18 deg C",
              recommendations: [
                {
                  sequence: "1",
                  text:
                    "Ensure staff are educated to run AC systems for comfort and efficiency by setting the AC system temperature to circa 22 deg C +/- 1 deg C.",
                },
              ],
            },
            dead_band: {
              note:
                "System dead-bands for the indoor unit are set at manufacture stage, these are considered satisfactory.",
              recommendations: [
                {
                  sequence: "1",
                  text:
                    "There were LPHW ceiling heaters within the same zones as AC systems and it was unclear from the BMS panel whether interlocks were provided between the systems to prevent both operating simultaneously. This should be investigated at head office were the BMS is set from and ensure that the AC systems do not operate at the same time as the heating and that adequate dead-bands are configured between the systems.",
                },
              ],
            },
            capacity: {
              note: "",
              recommendations: [
                { sequence: "1", text: "No recommendation required." },
              ],
              flag: true,
            },
            airflow: {
              note: "N/A Unit is not ducted type",
              recommendations: [
                {
                  sequence: "1",
                  text: "Considered satisfactory, no recommendation required.",
                },
              ],
            },
            guidance_controls: {
              note: "Provision of Guidance notices would be useful.",
              recommendations: [
                {
                  sequence: "1",
                  text:
                    "Consider providing ‘Good Practise Guideline’ notices (laminated sheet adjacent each AC controller) including ‘simple step’ recommendations on how to operate the systems efficiently.",
                },
              ],
              flag: false,
            },
          },
        },
      ],
    }.freeze

    it "should read the appropriate values from the XML doc" do
      test_xml_doc(supported_schema, asserted_keys)
    end

    it "returns the expect error without a valid schema type" do
      expect {
        ViewModel::AcReportWrapper.new "", "invalid"
      }.to raise_error.with_message "Unsupported schema type"
    end
  end
end
