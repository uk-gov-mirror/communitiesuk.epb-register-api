require_relative "xml_view_test_helper"
require "active_support/core_ext/hash/deep_merge"

describe ViewModel::SapWrapper do
  context "when calling to_hash" do
    let(:schemas) do
      heat_demand_current_unsupported = {
        different_buried_fields: {
          heat_demand: {
            current_space_heating_demand: nil,
            current_water_heating_demand: nil,
          },
        },
      }

      heat_demand_impact_of_unsupported = {
        different_buried_fields: {
          heat_demand: {
            impact_of_cavity_insulation: nil,
            impact_of_loft_insulation: nil,
            impact_of_solid_wall_insulation: nil,
          },
        },
      }

      heat_demand_unsupported =
        heat_demand_current_unsupported.deep_merge(
          heat_demand_impact_of_unsupported,
        )

      is_ni = {
        different_fields: {
          recommended_improvements: [
            {
              energy_performance_band_improvement: "e",
              energy_performance_rating_improvement: 50,
              environmental_impact_rating_improvement: 50,
              green_deal_category_code: nil,
              improvement_category: "1",
              improvement_code: "5",
              improvement_description: nil,
              improvement_title: "",
              improvement_type: "A",
              indicative_cost: "£100 - £350",
              sequence: 1,
              typical_saving: "360",
            },
            {
              energy_performance_band_improvement: "d",
              energy_performance_rating_improvement: 60,
              environmental_impact_rating_improvement: 64,
              green_deal_category_code: nil,
              improvement_category: "2",
              improvement_code: "1",
              improvement_description: nil,
              improvement_title: "",
              improvement_type: "B",
              indicative_cost: "2000",
              sequence: 2,
              typical_saving: "99",
            },
          ],
        },
        different_buried_fields: {
          heat_demand: {
            impact_of_cavity_insulation: nil,
            impact_of_loft_insulation: nil,
            impact_of_solid_wall_insulation: nil,
          },
        },
      }

      is_ni_pre_17 =
        {
          unsupported_fields: %i[tenure],
          different_fields: {
            property_age_band: "1750",
            recommended_improvements: [
              {
                energy_performance_band_improvement: "e",
                energy_performance_rating_improvement: 50,
                environmental_impact_rating_improvement: 50,
                green_deal_category_code: nil,
                improvement_category: "1",
                improvement_code: "5",
                improvement_description: nil,
                improvement_title: "",
                improvement_type: "A",
                indicative_cost: nil,
                sequence: 1,
                typical_saving: "360",
              },
              {
                energy_performance_band_improvement: "d",
                energy_performance_rating_improvement: 60,
                environmental_impact_rating_improvement: 64,
                green_deal_category_code: nil,
                improvement_category: "2",
                improvement_code: "1",
                improvement_description: nil,
                improvement_title: "",
                improvement_type: "B",
                indicative_cost: nil,
                sequence: 2,
                typical_saving: "99",
              },
            ],
            property_summary: [
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "walls",
                description: "Brick walls",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "walls",
                description: "Brick walls",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "roof",
                description: "Slate roof",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "roof",
                description: "slate roof",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "floor",
                description: "Tiled floor",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "floor",
                description: "Tiled floor",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "windows",
                description: "Glass window",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "main_heating",
                description: "Gas boiler",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "main_heating_controls",
                description: "Thermostat",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "secondary_heating",
                description: "Electric heater",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "hot_water",
                description: "Gas boiler",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "lighting",
                description: "Energy saving bulbs",
              },
              {
                description: "Draft Exclusion",
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "air_tightness",
              },
            ],
          },
        }.deep_merge(heat_demand_unsupported)

      is_pre_15_rdsap = {
        different_fields: {
          property_summary: [
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "wall",
              description: "Brick walls",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "wall",
              description: "Brick walls",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "roof",
              description: "Slate roof",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "roof",
              description: "slate roof",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "floor",
              description: "Tiled floor",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "floor",
              description: "Tiled floor",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "window",
              description: "Glass window",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "main_heating",
              description: "Gas boiler",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "main_heating_controls",
              description: "Thermostat",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "hot_water",
              description: "Gas boiler",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "lighting",
              description: "Energy saving bulbs",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "secondary_heating",
              description: "Electric heater",
            },
          ],
        },
      }

      is_pre_14_rdsap = {
        different_fields: {
          recommended_improvements: [
            {
              energy_performance_band_improvement: "e",
              energy_performance_rating_improvement: 50,
              environmental_impact_rating_improvement: 50,
              green_deal_category_code: nil,
              improvement_category: "1",
              improvement_code: nil,
              improvement_description: "",
              improvement_title: "",
              improvement_type: nil,
              indicative_cost: nil,
              sequence: 1,
              typical_saving: "360",
            },
            {
              energy_performance_band_improvement: "d",
              energy_performance_rating_improvement: 60,
              environmental_impact_rating_improvement: 64,
              green_deal_category_code: nil,
              improvement_category: "2",
              improvement_code: nil,
              improvement_description: "Improvement desc",
              improvement_title: "",
              improvement_type: nil,
              indicative_cost: nil,
              sequence: 2,
              typical_saving: "99",
            },
          ],
        },
      }

      is_pre_15 =
        {
          different_fields: {
            recommended_improvements: [
              {
                energy_performance_band_improvement: "e",
                energy_performance_rating_improvement: 50,
                environmental_impact_rating_improvement: 50,
                green_deal_category_code: nil,
                improvement_category: "1",
                improvement_code: "5",
                improvement_description: nil,
                improvement_title: "",
                improvement_type: "A",
                indicative_cost: nil,
                sequence: 1,
                typical_saving: "360",
              },
              {
                energy_performance_band_improvement: "d",
                energy_performance_rating_improvement: 60,
                environmental_impact_rating_improvement: 64,
                green_deal_category_code: nil,
                improvement_category: "2",
                improvement_code: nil,
                improvement_description: "Improvement desc",
                improvement_title: "",
                improvement_type: "B",
                indicative_cost: nil,
                sequence: 2,
                typical_saving: "99",
              },
            ],
            property_summary: [
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "walls",
                description: "Brick walls",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "walls",
                description: "Brick walls",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "roof",
                description: "Slate roof",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "roof",
                description: "slate roof",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "floor",
                description: "Tiled floor",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "floor",
                description: "Tiled floor",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "windows",
                description: "Glass window",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "main_heating",
                description: "Gas boiler",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "main_heating_controls",
                description: "Thermostat",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "secondary_heating",
                description: "Electric heater",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "hot_water",
                description: "Gas boiler",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "lighting",
                description: "Energy saving bulbs",
              },
              {
                energy_efficiency_rating: 0,
                environmental_efficiency_rating: 0,
                name: "air_tightness",
                description: "Draft Exclusion",
              },
            ],
          },
        }.deep_merge heat_demand_unsupported

      is_pre_14 = {
        unsupported_fields: %i[related_party_disclosure_number tenure],
        different_fields: {
          related_party_disclosure_text: "Not related to owner",
        },
      }

      is_pre_13 = {
        unsupported_fields: %i[
          dwelling_type
          related_party_disclosure_number
          tenure
        ],
        different_fields: {
          total_floor_area: "",
          recommended_improvements: [
            {
              energy_performance_band_improvement: "e",
              energy_performance_rating_improvement: 50,
              environmental_impact_rating_improvement: 50,
              green_deal_category_code: nil,
              improvement_category: "1",
              improvement_code: nil,
              improvement_description: "",
              improvement_title: "",
              improvement_type: "A",
              indicative_cost: nil,
              sequence: 1,
              typical_saving: "360",
            },
            {
              energy_performance_band_improvement: "d",
              energy_performance_rating_improvement: 60,
              environmental_impact_rating_improvement: 64,
              green_deal_category_code: nil,
              improvement_category: "2",
              improvement_code: nil,
              improvement_description: "Improvement desc",
              improvement_title: "",
              improvement_type: "B",
              indicative_cost: nil,
              sequence: 2,
              typical_saving: "99",
            },
          ],
        },
      }

      is_ni_rdsap_pre_15 = {
        different_fields: {
          property_summary: [
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "wall",
              description: "Brick walls",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "wall",
              description: "Brick walls",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "roof",
              description: "Slate roof",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "roof",
              description: "slate roof",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "floor",
              description: "Tiled floor",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "floor",
              description: "Tiled floor",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "window",
              description: "Glass window",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "main_heating",
              description: "Gas boiler",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "main_heating_controls",
              description: "Thermostat",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "hot_water",
              description: "Gas boiler",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "lighting",
              description: "Energy saving bulbs",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "secondary_heating",
              description: "Electric heater",
            },
          ],
        },
      }

      is_ni_rdsap = {
        different_fields: {
          recommended_improvements: [
            {
              energy_performance_band_improvement: "e",
              energy_performance_rating_improvement: 50,
              environmental_impact_rating_improvement: 50,
              green_deal_category_code: "1",
              improvement_category: "1",
              improvement_code: "5",
              improvement_description: nil,
              improvement_title: "",
              improvement_type: "A",
              indicative_cost: "£100 - £350",
              sequence: 1,
              typical_saving: "360",
            },
            {
              energy_performance_band_improvement: "d",
              energy_performance_rating_improvement: 60,
              environmental_impact_rating_improvement: 64,
              green_deal_category_code: "3",
              improvement_category: "2",
              improvement_code: "1",
              improvement_description: nil,
              improvement_title: "",
              improvement_type: "B",
              indicative_cost: "2000",
              sequence: 2,
              typical_saving: "99",
            },
          ],
        },
      }

      is_rdsap = {
        different_fields: {
          type_of_assessment: "RdSAP",
          property_age_band: "A",
          property_summary: [
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "wall",
              description: "Brick walls",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "wall",
              description: "Brick walls",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "roof",
              description: "Slate roof",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "roof",
              description: "slate roof",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "floor",
              description: "Tiled floor",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "floor",
              description: "Tiled floor",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "window",
              description: "Glass window",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "main_heating",
              description: "Gas boiler",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "main_heating",
              description: "Gas boiler",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "main_heating_controls",
              description: "Thermostat",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "main_heating_controls",
              description: "Thermostat",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "hot_water",
              description: "Gas boiler",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "lighting",
              description: "Energy saving bulbs",
            },
            {
              energy_efficiency_rating: 0,
              environmental_efficiency_rating: 0,
              name: "secondary_heating",
              description: "Electric heater",
            },
          ],
        },
      }

      has_uprn = {
        different_fields: {
          address_id: "UPRN-000000000000",
        },
        different_buried_fields: {
          address: {
            address_id: "UPRN-000000000000",
          },
        },
      }

      [
        { schema: "SAP-Schema-NI-18.0.0" }.deep_merge(has_uprn).deep_merge(
          is_ni,
        ),
        { schema: "SAP-Schema-NI-17.4" }.merge(is_ni),
        { schema: "SAP-Schema-NI-17.3" }.merge(is_ni),
        { schema: "SAP-Schema-NI-17.2", type: "sap" }.merge(is_ni),
        { schema: "SAP-Schema-NI-17.2", type: "rdsap" }.deep_merge(is_rdsap)
          .deep_merge(is_ni_rdsap),
        { schema: "SAP-Schema-NI-17.1", type: "sap" }.merge(is_ni),
        { schema: "SAP-Schema-NI-17.1", type: "rdsap" }.deep_merge(is_rdsap)
          .deep_merge(is_ni_rdsap),
        { schema: "SAP-Schema-NI-17.0", type: "sap" }.merge(is_ni),
        { schema: "SAP-Schema-NI-17.0", type: "rdsap" }.deep_merge(is_rdsap)
          .deep_merge(is_ni_rdsap),
        { schema: "SAP-Schema-NI-16.1", type: "sap" }.merge(is_ni_pre_17),
        { schema: "SAP-Schema-NI-16.1", type: "rdsap" }.deep_merge(is_rdsap)
          .deep_merge(is_ni_rdsap),
        {
          schema: "SAP-Schema-NI-16.0",
          type: "sap",
          unsupported_fields: %i[tenure],
        }.merge(is_ni_pre_17),
        {
          schema: "SAP-Schema-NI-16.0",
          type: "rdsap",
          unsupported_fields: %i[tenure],
        }.deep_merge(is_rdsap).deep_merge(is_ni_rdsap),
        { schema: "SAP-Schema-NI-15.0", type: "sap" }.merge(is_ni_pre_17),
        {
          schema: "SAP-Schema-NI-15.0",
          type: "rdsap",
          unsupported_fields: %i[tenure],
        }.deep_merge(is_rdsap)
          .deep_merge(is_ni)
          .deep_merge(heat_demand_impact_of_unsupported),
        {
          schema: "SAP-Schema-14.2",
          type: "rdsap",
          unsupported_fields: %i[tenure],
          different_fields: {
            main_fuel_type: "10",
          },
        }.deep_merge(is_rdsap)
          .deep_merge(is_pre_15)
          .deep_merge(is_pre_15_rdsap)
          .deep_merge(heat_demand_unsupported),
        { schema: "SAP-Schema-NI-14.2", type: "sap" }.merge(is_ni_pre_17),
        {
          schema: "SAP-Schema-NI-14.2",
          type: "rdsap",
          unsupported_fields: %i[tenure],
          different_fields: {
            main_fuel_type: "10",
          },
        }.deep_merge(is_ni)
          .deep_merge(is_ni_pre_17)
          .deep_merge(is_rdsap)
          .deep_merge(is_ni_rdsap_pre_15)
          .deep_merge(heat_demand_unsupported),
        { schema: "SAP-Schema-NI-14.1", type: "sap" }.merge(is_ni_pre_17),
        {
          schema: "SAP-Schema-NI-14.1",
          type: "rdsap",
          unsupported_fields: %i[tenure],
          different_fields: {
            main_fuel_type: "10",
          },
        }.deep_merge(is_ni)
          .deep_merge(is_ni_pre_17)
          .deep_merge(is_rdsap)
          .deep_merge(is_ni_rdsap_pre_15)
          .deep_merge(heat_demand_unsupported),
        { schema: "SAP-Schema-NI-14.0", type: "sap" }.merge(is_ni_pre_17),
        {
          schema: "SAP-Schema-NI-14.0",
          type: "rdsap",
          unsupported_fields: %i[tenure],
          different_fields: {
            main_fuel_type: "10",
          },
        }.deep_merge(is_ni)
          .deep_merge(is_ni_pre_17)
          .deep_merge(is_rdsap)
          .deep_merge(is_ni_rdsap_pre_15)
          .deep_merge(heat_demand_unsupported),
        { schema: "SAP-Schema-NI-13.0", type: "sap" }.merge(is_ni_pre_17)
          .deep_merge(is_pre_14),
        {
          schema: "SAP-Schema-NI-13.0",
          type: "rdsap",
          different_fields: {
            main_fuel_type: "10",
          },
        }.deep_merge(is_ni)
          .deep_merge(is_ni_pre_17)
          .deep_merge(is_rdsap)
          .deep_merge(is_pre_14)
          .deep_merge(is_ni_rdsap_pre_15)
          .deep_merge(is_pre_14_rdsap)
          .deep_merge(heat_demand_unsupported),
        { schema: "SAP-Schema-NI-12.0", type: "sap" }.merge(is_ni_pre_17)
          .deep_merge(is_pre_14)
          .deep_merge(is_pre_13),
        {
          schema: "SAP-Schema-NI-12.0",
          type: "rdsap",
          different_fields: {
            main_fuel_type: "10",
          },
        }.deep_merge(is_ni)
          .deep_merge(is_ni_pre_17)
          .deep_merge(is_rdsap)
          .deep_merge(is_pre_14)
          .deep_merge(is_pre_13)
          .deep_merge(is_ni_rdsap_pre_15)
          .deep_merge(is_pre_14_rdsap)
          .deep_merge(heat_demand_unsupported),
        { schema: "SAP-Schema-NI-11.2", type: "sap" }.merge(is_ni_pre_17)
          .deep_merge(is_pre_14)
          .deep_merge(is_pre_13),
        {
          schema: "SAP-Schema-NI-11.2",
          type: "rdsap",
          different_fields: {
            main_fuel_type: "10",
          },
        }.deep_merge(is_ni)
          .deep_merge(is_ni_pre_17)
          .deep_merge(is_rdsap)
          .deep_merge(is_pre_14)
          .deep_merge(is_pre_13)
          .deep_merge(is_ni_rdsap_pre_15)
          .deep_merge(is_pre_14_rdsap)
          .deep_merge(heat_demand_unsupported),
      ]
    end

    let(:assertion) do
      {
        type_of_assessment: "SAP",
        assessment_id: "0000-0000-0000-0000-0000",
        date_of_expiry: "2030-05-03",
        date_of_assessment: "2020-05-04",
        date_of_registration: "2020-05-04",
        date_registered: "2020-05-04",
        address_id: "LPRN-0000000000",
        address_line1: "1 Some Street",
        address_line2: "Some Area",
        address_line3: "Some County",
        address_line4: nil,
        town: "Whitbury",
        postcode: "A0 0AA",
        address: {
          address_id: "LPRN-0000000000",
          address_line1: "1 Some Street",
          address_line2: "Some Area",
          address_line3: "Some County",
          address_line4: nil,
          town: "Whitbury",
          postcode: "A0 0AA",
        },
        assessor: {
          scheme_assessor_id: "SPEC000000",
          name: "Mr Test Boi TST",
          contact_details: {
            email: "a@b.c",
            telephone: "111222333",
          },
        },
        current_carbon_emission: 2.4,
        current_energy_efficiency_band: "e",
        current_energy_efficiency_rating: 50,
        dwelling_type: "Mid-terrace house",
        estimated_energy_cost: "689.83",
        main_fuel_type: "36",
        heat_demand: {
          current_space_heating_demand: 13_120,
          current_water_heating_demand: 2285,
          impact_of_cavity_insulation: -122,
          impact_of_loft_insulation: -2114,
          impact_of_solid_wall_insulation: -3560,
        },
        heating_cost_current: "365.98",
        heating_cost_potential: "250.34",
        hot_water_cost_current: "200.40",
        hot_water_cost_potential: "180.43",
        lighting_cost_current: "123.45",
        lighting_cost_potential: "84.23",
        potential_carbon_emission: 1.4,
        potential_energy_efficiency_band: "c",
        potential_energy_efficiency_rating: 72,
        potential_energy_saving: "174.83",
        primary_energy_use: "230",
        energy_consumption_potential: "88",
        property_age_band: "1750",
        property_summary: [
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "walls",
            description: "Brick walls",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "walls",
            description: "Brick walls",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "roof",
            description: "Slate roof",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "roof",
            description: "slate roof",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "floor",
            description: "Tiled floor",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "floor",
            description: "Tiled floor",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "windows",
            description: "Glass window",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "main_heating",
            description: "Gas boiler",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "main_heating",
            description: "Gas boiler",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "main_heating_controls",
            description: "Thermostat",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "main_heating_controls",
            description: "Thermostat",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "secondary_heating",
            description: "Electric heater",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "hot_water",
            description: "Gas boiler",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "lighting",
            description: "Energy saving bulbs",
          },
          {
            energy_efficiency_rating: 0,
            environmental_efficiency_rating: 0,
            name: "air_tightness",
            description: "Draft Exclusion",
          },
        ],
        recommended_improvements: [
          {
            energy_performance_rating_improvement: 50,
            energy_performance_band_improvement: "e",
            environmental_impact_rating_improvement: 50,
            green_deal_category_code: "1",
            improvement_category: "6",
            improvement_code: "5",
            improvement_description: nil,
            improvement_title: "",
            improvement_type: "Z3",
            indicative_cost: "£100 - £350",
            sequence: 1,
            typical_saving: "360",
          },
          {
            energy_performance_rating_improvement: 60,
            energy_performance_band_improvement: "d",
            environmental_impact_rating_improvement: 64,
            green_deal_category_code: "3",
            improvement_category: "2",
            improvement_code: nil,
            improvement_description: "Improvement desc",
            improvement_title: "",
            improvement_type: "Z2",
            indicative_cost: "2000",
            sequence: 2,
            typical_saving: "99",
          },
        ],
        related_party_disclosure_number: 1,
        related_party_disclosure_text: nil,
        tenure: "1",
        total_floor_area: 69.0,
        status: "ENTERED",
        environmental_impact_current: "52",
      }
    end

    it "reads the appropriate values" do
      test_xml_doc(schemas, assertion)
    end
  end

  context "when calling to_report" do
    let(:schemas) do
      [
        {
          schema: "SAP-Schema-NI-18.0.0",
          different_fields: {
            building_reference_number: "UPRN-000000000000",
            extension_count: nil,
            construction_age_band: "England and Wales: 2007-2011",
            multi_glaze_proportion: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-17.4",
          different_fields: {
            extension_count: nil,
            construction_age_band: "England and Wales: 2007-2011",
            multi_glaze_proportion: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-17.3",
          different_fields: {
            extension_count: nil,
            construction_age_band: "England and Wales: 2007-2011",
            multi_glaze_proportion: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-17.2",
          type: "sap",
          different_fields: {
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-17.2",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: "11",
            low_energy_fixed_lighting_outlets_count: "9",
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-17.1",
          type: "sap",
          different_fields: {
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-17.1",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: "11",
            low_energy_fixed_lighting_outlets_count: "9",
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-17.0",
          type: "sap",
          different_fields: {
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-17.0",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: "11",
            low_energy_fixed_lighting_outlets_count: "9",
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-16.1",
          type: "sap",
          different_fields: {
            tenure: nil,
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
          },
        },
        {
          schema: "SAP-Schema-NI-16.1",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: "11",
            low_energy_fixed_lighting_outlets_count: "9",
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-16.0",
          type: "sap",
          different_fields: {
            tenure: nil,
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
          },
        },
        {
          schema: "SAP-Schema-NI-16.0",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            transaction_type: "not sale or rental",
            tenure: nil,
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: "11",
            low_energy_fixed_lighting_outlets_count: "9",
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-15.0",
          type: "sap",
          different_fields: {
            tenure: nil,
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
          },
        },
        {
          schema: "SAP-Schema-NI-15.0",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            tenure: nil,
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: "11",
            low_energy_fixed_lighting_outlets_count: "9",
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-14.2",
          type: "sap",
          different_fields: {
            tenure: nil,
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
          },
        },
        {
          schema: "SAP-Schema-NI-14.2",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            tenure: nil,
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: nil,
            low_energy_fixed_lighting_outlets_count: nil,
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            mainheat_description: "Gas boiler",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            main_fuel: "Solid fuel: dual fuel appliance (mineral and wood)",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-14.1",
          type: "sap",
          different_fields: {
            tenure: nil,
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
            number_open_fireplaces: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-14.1",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            tenure: nil,
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: nil,
            low_energy_fixed_lighting_outlets_count: nil,
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            mainheat_description: "Gas boiler",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            main_fuel: "Solid fuel: dual fuel appliance (mineral and wood)",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-14.0",
          type: "sap",
          different_fields: {
            tenure: nil,
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
            number_open_fireplaces: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-14.0",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            tenure: nil,
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: nil,
            low_energy_fixed_lighting_outlets_count: nil,
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            mainheat_description: "Gas boiler",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            main_fuel: "Solid fuel: dual fuel appliance (mineral and wood)",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-13.0",
          type: "sap",
          different_fields: {
            tenure: nil,
            environment_impact_potential: "93",
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
            number_open_fireplaces: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-13.0",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            tenure: nil,
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: nil,
            low_energy_fixed_lighting_outlets_count: nil,
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            mainheat_description: "Gas boiler",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            main_fuel: "Solid fuel: dual fuel appliance (mineral and wood)",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-12.0",
          type: "sap",
          different_fields: {
            tenure: nil,
            environment_impact_potential: "93",
            report_type: "3",
            total_floor_area: nil,
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
            number_open_fireplaces: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-12.0",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            tenure: nil,
            transaction_type: "not sale or rental",
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: "56",
            total_floor_area: nil,
            multi_glaze_proportion: "100",
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: nil,
            low_energy_fixed_lighting_outlets_count: nil,
            number_open_fireplaces: "2",
            built_form: "End-Terrace",
            mainheat_description: "Gas boiler",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            extension_count: "1",
            main_fuel: "Solid fuel: dual fuel appliance (mineral and wood)",
            glazed_type: "double glazing installed during or after 2002",
            number_habitable_rooms: "5",
            number_heated_rooms: "5",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: "natural",
          },
        },
        {
          schema: "SAP-Schema-NI-11.2",
          type: "sap",
          different_fields: {
            tenure: nil,
            transaction_type: nil,
            environment_impact_potential: "93",
            total_floor_area: nil,
            report_type: "3",
            extension_count: nil,
            multi_glaze_proportion: nil,
            mainheat_description: "Gas boiler",
            co2_emiss_curr_per_floor_area: nil,
            low_energy_lighting: "50",
            low_energy_fixed_lighting_outlets_count: "4",
            built_form: "Semi-Detached",
            floor_level: nil,
          },
        },
        {
          schema: "SAP-Schema-NI-11.2",
          type: "rdsap",
          different_fields: {
            construction_age_band: "England and Wales: before 1900",
            tenure: nil,
            transaction_type: nil,
            environment_impact_potential: "70",
            co2_emiss_curr_per_floor_area: nil,
            total_floor_area: nil,
            multi_glaze_proportion: nil,
            low_energy_lighting: nil,
            fixed_lighting_outlets_count: nil,
            low_energy_fixed_lighting_outlets_count: nil,
            wind_turbine_count: nil,
            heat_loss_corridor: "no corridor",
            mainheat_description: "Gas boiler",
            report_type: "2",
            energy_tariff: "Single",
            floor_level: nil,
            floor_height: "2.45",
            main_fuel: "Solid fuel: dual fuel appliance (mineral and wood)",
            number_habitable_rooms: "4",
            number_heated_rooms: "4",
            photo_supply: "0",
            solar_water_heating_flag: "N",
            mechanical_ventilation: nil,
            flat_storey_count: "3",
          },
        },
      ]
    end

    let(:assertion) do
      {
        assessment_id: "0000-0000-0000-0000-0000",
        inspection_date: "2020-05-04",
        lodgement_date: "2020-05-04",
        building_reference_number: "LPRN-0000000000",
        address1: "1 Some Street",
        address2: "Some Area",
        address3: "Some County",
        posttown: "Whitbury",
        postcode: "A0 0AA",
        construction_age_band: "1750",
        current_energy_rating: "e",
        potential_energy_rating: "c",
        current_energy_efficiency: "50",
        potential_energy_efficiency: "72",
        property_type: "House",
        tenure: "Owner-occupied",
        transaction_type: "marketed sale",
        environment_impact_current: "52",
        environment_impact_potential: "74",
        energy_consumption_current: "230",
        energy_consumption_potential: "88",
        co2_emissions_current: "2.4",
        co2_emiss_curr_per_floor_area: "20",
        co2_emissions_potential: "1.4",
        heating_cost_current: "365.98",
        heating_cost_potential: "250.34",
        hot_water_cost_current: "200.40",
        hot_water_cost_potential: "180.43",
        lighting_cost_current: "123.45",
        lighting_cost_potential: "84.23",
        total_floor_area: "69",
        mains_gas_flag: nil,
        flat_top_storey: "N",
        flat_storey_count: nil,
        multi_glaze_proportion: "50",
        glazed_area: nil,
        number_habitable_rooms: nil,
        number_heated_rooms: nil,
        low_energy_lighting: "100",
        fixed_lighting_outlets_count: "8",
        low_energy_fixed_lighting_outlets_count: "8",
        number_open_fireplaces: "0",
        hotwater_description: "Gas boiler",
        hot_water_energy_eff: "N/A",
        hot_water_env_eff: "N/A",
        wind_turbine_count: "0",
        heat_loss_corridor: nil,
        unheated_corridor_length: nil,
        windows_description: "Glass window",
        windows_energy_eff: "N/A",
        windows_env_eff: "N/A",
        secondheat_description: "Electric heater",
        sheating_energy_eff: "N/A",
        sheating_env_eff: "N/A",
        lighting_description: "Energy saving bulbs",
        lighting_energy_eff: "N/A",
        lighting_env_eff: "N/A",
        photo_supply: nil,
        built_form: "Detached",
        mainheat_description: "Gas boiler, Gas boiler",
        report_type: "3",
        mainheatcont_description: "Thermostat",
        roof_description: "Slate roof",
        roof_energy_eff: "N/A",
        roof_env_eff: "N/A",
        walls_description: "Brick walls",
        walls_energy_eff: "N/A",
        walls_env_eff: "N/A",
        energy_tariff: "standard tariff",
        floor_level: "1",
        mainheat_energy_eff: "N/A",
        mainheat_env_eff: "N/A",
        extension_count: "0",
        solar_water_heating_flag: nil,
        mechanical_ventilation: nil,
        floor_height: "2.4",
        main_fuel: "Electricity: electricity sold to grid",
        floor_description: "Tiled floor",
        floor_energy_eff: "N/A",
        floor_env_eff: "N/A",
        mainheatc_energy_eff: "N/A",
        mainheatc_env_eff: "N/A",
        glazed_type: nil,
      }
    end

    it "reads the appropriate values" do
      test_xml_doc(schemas, assertion, :to_report)
    end
  end
end
