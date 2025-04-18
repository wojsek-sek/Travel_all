@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight view entity'
@Search.searchable: true
define view entity zi_fe_flig_001653
  as select from zfe_aflig_001653 as Flight
  association [1] to zi_fe_carr_001653 as _Airline on $projection.AirlineID = _Airline.AirlineID
  association [1] to zi_fe_conn_001653 as _Connection on $projection.ConnectionID = _Connection.ConnectionID and $projection.AirlineID = _Connection.AirlineID
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8 
  @ObjectModel.text.association: '_Airline'
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'zi_fe_carr_001653', 
      element: 'AirlineID'
    }
  } ]
  key Flight.carrier_id as AirlineID,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8 
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'zi_fe_conn_001653', 
      element: 'ConnectionID'
    }, 
    additionalBinding: [ {
      element: 'AirlineID', 
      localElement: 'AirlineID'
    } ]
  } ]
  key Flight.connection_id as ConnectionID,
  key Flight.flight_date as FlightDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  Flight.price as Price,
  Flight.currency_code as CurrencyCode,
  Flight.plane_type_id as PlaneType,
  Flight.seats_max as MaximumSeats,
  Flight.seats_occupied as OccupiedSeats,
  _Airline,
  _Connection,
  _Currency
  
}
