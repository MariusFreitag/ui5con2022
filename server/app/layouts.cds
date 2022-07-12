using TravelService from '../srv/travel-service';
using from '../db/schema';
using from './capabilities';

annotate TravelService.Travel with @UI : {
/*
  Identification annotation defines actions shown in the object page header
 */
  Identification : [
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.acceptTravel',   Label  : '{i18n>AcceptTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.rejectTravel',   Label  : '{i18n>RejectTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.deductDiscount', Label  : '{i18n>DeductDiscount}' }
  ],
  /*
  HeaderInfo TypeName defines the subtitle on object page header
  TypeNamePlural defines the List Report table header
 */
  HeaderInfo : {
    TypeName       : '{i18n>Travel}',
    TypeNamePlural : '{i18n>Travels}',
    Title          : {
      $Type : 'UI.DataField',
      Value : Description
    },
    Description    : {
      $Type : 'UI.DataField',
      Value : TravelID
    }
  },
  /*
  PresentationVariant defines a default sort order considered for List Report selection
 */
  PresentationVariant : {
    Text           : 'Default',
    Visualizations : ['@UI.LineItem'],
    SortOrder      : [{
      $Type      : 'Common.SortOrderType',
      Property   : TravelID,
      Descending : true
    }]
  },
  /*
  SelectionFields define the filters shown in the List Report filter bar
 */
  SelectionFields : [
    TravelID,
    to_Agency_AgencyID,
    to_Customer_CustomerID,
    TravelStatus_code
  ],
  /*
  LineItem annotation define the table columns. DataFieldForAction defines actions shown in the table toolbar
 */
  LineItem : [
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.acceptTravel',   Label  : '{i18n>AcceptTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.rejectTravel',   Label  : '{i18n>RejectTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.deductDiscount', Label  : '{i18n>DeductDiscount}' },
    { Value : TravelID               },
    { Value : to_Agency_AgencyID     },
    { Value : to_Customer_CustomerID },
    { Value : BeginDate              },
    { Value : EndDate                },
    { Value : BookingFee             },
    { Value : TotalPrice             },
    { Value : TravelStatus_code      },
    { Value : Description            }
  ],
  /*
  Facets define the layout of the form field groups on the object page
  Collection Facets group together reference facets, each representing a form field group
  */

  Facets : [{
    $Type  : 'UI.CollectionFacet',
    Label  : '{i18n>GeneralInformation}',
    ID     : 'Travel',
    Facets : [
      {  // travel details
        $Type  : 'UI.ReferenceFacet',
        ID     : 'TravelData',
        Target : '@UI.FieldGroup#TravelData',
        Label  : '{i18n>GeneralInformation}'
      },
      {  // price information
        $Type  : 'UI.ReferenceFacet',
        ID     : 'PriceData',
        Target : '@UI.FieldGroup#PriceData',
        Label  : '{i18n>Prices}'
      },
      {  // date information
        $Type  : 'UI.ReferenceFacet',
        ID     : 'DateData',
        Target : '@UI.FieldGroup#DateData',
        Label  : '{i18n>Dates}'
      }
      ]
  }, {  // booking list
    $Type  : 'UI.ReferenceFacet',
    Target : 'to_Booking/@UI.PresentationVariant',
    Label  : '{i18n>Bookings}'
  }],

  FieldGroup#TravelData : { Data : [
    { Value : TravelID               },
    { Value : to_Agency_AgencyID     },
    { Value : to_Customer_CustomerID },
    { Value : Description            },
    {
      $Type       : 'UI.DataField',
      Value       : TravelStatus_code,
      Criticality : TravelStatus.criticality,
      Label : '{i18n>Status}' // label only necessary if differs from title of element
    }
  ]},
  FieldGroup #DateData : {Data : [
    { $Type : 'UI.DataField', Value : BeginDate },
    { $Type : 'UI.DataField', Value : EndDate }
  ]},
  FieldGroup #PriceData : {Data : [
    { $Type : 'UI.DataField', Value : BookingFee },
    { $Type : 'UI.DataField', Value : TotalPrice }
  ]}
};

annotate TravelService.Booking with @UI : {
  Identification : [
    { Value : BookingID },
  ],
  HeaderInfo : {
    TypeName       : '{i18n>Bookings}',
    TypeNamePlural : '{i18n>Bookings}',
    Title          : { Value : to_Customer.LastName },
    Description    : { Value : BookingID }
  },
  // Exercise 5: add chart header facet

  PresentationVariant : {
    Text           : 'Default',
    Visualizations : ['@UI.LineItem'],
  },
  SelectionFields : [],
  LineItem                : {
  //Exercise 3.1 Add Table Line Criticality

  $value : [
    {
        $Type : 'UI.DataField',
        Value : BookingID,
        ![@UI.Importance] : #High
    },
  //  Exercise 5: add chart table column

    { Value : to_Customer_CustomerID, ![@UI.Importance] : #High },
    { Value : to_Carrier_AirlineID, ![@UI.Importance] : #High   },
    { Value : ConnectionID,         ![@UI.Importance] : #High   },
    { Value : FlightDate, ![@UI.Importance] : #High             },
    { Value : FlightPrice, ![@UI.Importance] : #High            },
    { Value : BookingStatus_code     }
  ]},
  Facets : [{
    $Type  : 'UI.CollectionFacet',
    Label  : '{i18n>GeneralInformation}',
    ID     : 'Booking',
    Facets : [{  // booking details
      $Type  : 'UI.ReferenceFacet',
      ID     : 'BookingData',
      Target : '@UI.FieldGroup#GeneralInformation',
      Label  : '{i18n>Booking}'
    }, {  // flight details
      $Type  : 'UI.ReferenceFacet',
      ID     : 'FlightData',
      Target : '@UI.FieldGroup#Flight',
      Label  : '{i18n>Flight}'
    }]
  }, {  // supplements list
    $Type  : 'UI.ReferenceFacet',
    Target : 'to_BookSupplement/@UI.LineItem',
    Label  : '{i18n>BookingSupplements}'
  }],
  FieldGroup #GeneralInformation : { Data : [
    { Value : BookingID              },
    { Value : BookingDate,           },
    { Value : to_Customer_CustomerID },
    { Value : BookingDate,           },
    { Value : BookingStatus_code     }
  ]},
  FieldGroup #Flight : { Data : [
    { Value : to_Carrier_AirlineID   },
    { Value : ConnectionID           },
    { Value : FlightDate             },
    { Value : FlightPrice            }
  ]}
};
annotate TravelService.BookingSupplement with @UI : {
  Identification : [
    { Value : BookingSupplementID }
  ],
  HeaderInfo : {
    TypeName       : '{i18n>BookingSupplement}',
    TypeNamePlural : '{i18n>BookingSupplements}',
    Title          : { Value : BookingSupplementID },
    Description    : { Value : BookingSupplementID }
  },
  LineItem : [
    { Value : BookingSupplementID                                       },
    { Value : to_Supplement_SupplementID, Label : '{i18n>ProductID}'    },
    { Value : Price,                      Label : '{i18n>ProductPrice}' }
  ],
};
// Exercise 5: Booking entity Chart annotation


annotate TravelService.BookedFlights with @(
    UI : {
        SelectionFields : [
          to_Agency_AgencyID,
          TravelStatus_code
        ]
    }
);

annotate TravelService.Airline with @(
    UI : {
      FieldGroup #Main : {
          $Type : 'UI.FieldGroupType',
          Data : [
            {
                $Type : 'UI.DataField',
                Value : AirlineID
            },
            {
                $Type : 'UI.DataField',
                Value : CurrencyCode_code
            },
          ]
      },
      FieldGroup #Logo : {
          $Type : 'UI.FieldGroupType',
          Data : [
            {
                $Type : 'UI.DataFieldWithUrl',
                Label: '',
                Value : AirlinePicURL,
            }
          ]
      },
      HeaderInfo : {
        TypeName       : 'Airline',
        TypeNamePlural : 'Airlines',
        Title          : { Value : Name }
      },
      HeaderFacets : [
          {
              $Type : 'UI.ReferenceFacet',
              Target : '@UI.FieldGroup#Logo'
          },
          {
              $Type : 'UI.ReferenceFacet',
              Target : '@UI.FieldGroup#Main'
          }
      ],
      Facets : [
        {  
          $Type  : 'UI.ReferenceFacet',
          ID     : 'TravelData',
          Target : 'to_Bookings/@UI.LineItem'
        }
      ]
    }
);