within AixLib.FastHVAC.Components.Storage.BaseClasses;
model WasteWaterStorageControl

  parameter Modelica.SIunits.Length s_biofilm_max = 0.005
    "max thickness of biofilm, when cleaning should be started";
  parameter Modelica.SIunits.Length s_biofilm_min= 0.0005
    "min thickness of biofilm, that could be reached by cleaning";

  parameter Modelica.SIunits.Temperature T_HeatingWater_set = 273.15 + 61
    "max Temperature of third highest layer of heatingwater in storage for leaving heatpump on";
  parameter Modelica.SIunits.Temperature T_WasteWater_upper_min = 273.15 + 15
    "min Temperature of highest layer in wastewaterstorage for leaving heatpump on";
      parameter Modelica.SIunits.Temperature T_WasteWater_min_cleaning = 273.15 + 10
    "min Temperature of incoming wastewater for starting cleaning process";
  parameter Modelica.SIunits.Temperature T_HeatingWater_min_cleaning = 273.15 + 45
    "min Temperature of highest layer of heatingwater in storage for starting cleaning process";

  parameter Modelica.SIunits.Density rho_WasteWater = 995
    "density wastewater";
   Modelica.SIunits.Volume V_storage "Volume of wastewater storage";
  parameter Modelica.SIunits.Length d_storage = 1 "Diameter of wastewater storage";
  parameter Modelica.SIunits.Length h_storage = 1 "Height of wastewater storage";
  parameter Modelica.SIunits.MassFlowRate dot_m_cond_pump_fix = 0.07
    "Massflowrate of condensor Pump if HP is on";
  parameter Modelica.SIunits.MassFlowRate dot_m_evap_pump_fix = 0.07
    "Massflowrate of evaporator Pump if HP is on";
  parameter Integer n_WasteWater_layers = 10
    "number of layers in wastewater storage";
  parameter Integer n_HeatingWater_layers = 10
    "number of layers in wastewater storage";
  Integer t_releasing "time duration of realeasing water + cleaning process";
  parameter Integer t_cleaning = 3600 "time duration of cleaning process";
  Integer t_cleaning_end "";
  //Boolean iscleaning "true if cleaning is started";
  Boolean cleaning_finished "true if cleaning is finished";
  Integer time_cleaning_start "time when cleaning starts";
  Modelica.SIunits.Volume V_WasteWater
    "Volume to simulate growing water level during fill process";
  Boolean bypass_forced_opened_value "true if bypass if forced to keep opened";
  Boolean bypass_forced_closed_value
                                    "true if bypass if forced to keep closed";


  Interfaces.EnthalpyPort_a WW_control_in
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  Interfaces.EnthalpyPort_b WW_control_out_storage
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
  Interfaces.EnthalpyPort_b WW_control_out_bypass
    annotation (Placement(transformation(extent={{-76,-108},{-56,-88}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={88,-44})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{54,-62},{66,-50}})));
  Valves.ThreeWayValve            threeWayValve annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-68})));
  Modelica.Blocks.Logical.Less less annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={24,-42})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{100,-30},{90,-20}})));
  Modelica.Blocks.Interfaces.RealInput T_WasteWaterStorage[n_WasteWater_layers]
    annotation (Placement(transformation(extent={{-116,36},{-92,68}})));
  Modelica.Blocks.Interfaces.RealOutput dot_m_evap_pump
    annotation (Placement(transformation(extent={{-98,-102},{-118,-82}})));
  Modelica.Blocks.Interfaces.RealInput T_HeatingWaterStorage[n_HeatingWater_layers]
    annotation (Placement(transformation(extent={{-116,60},{-92,86}})));

  Modelica.Blocks.Interfaces.RealInput s_biofilm
    annotation (Placement(transformation(extent={{128,-112},{88,-72}})));
  Sensors.TemperatureSensor wastewatertemperature annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-4,0})));
  Sensors.MassFlowSensor wastewatermassFlowRate annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,42})));
  Modelica.Blocks.Interfaces.RealOutput dot_m_cond_pump
    annotation (Placement(transformation(extent={{-98,-80},{-118,-60}})));

  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{72,-14},{82,-4}})));
  Modelica.Blocks.Logical.Nor nor
    annotation (Placement(transformation(extent={{38,-36},{50,-24}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{56,-44},{66,-34}})));
  Modelica.Blocks.Interfaces.BooleanOutput HP_ison annotation (Placement(transformation(extent={{-100,86},
            {-120,106}})));


  Modelica.Blocks.Sources.BooleanExpression bypass_forced_opened(y=
        bypass_forced_opened_value)
    annotation (Placement(transformation(extent={{14,-18},{34,2}})));
  Modelica.Blocks.Sources.BooleanExpression bypass_forced_closed(y=
        bypass_forced_closed_value)
    annotation (Placement(transformation(extent={{12,-42},{32,-22}})));

  Modelica.Blocks.Interfaces.BooleanOutput iscleaning(start=false) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-106})));
  Modelica.Blocks.Logical.OnOffController onOffController(bandwidth=5)
    annotation (Placement(transformation(extent={{-34,78},{-48,92}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-62,86},{-76,100}})));
  Modelica.Blocks.Sources.Constant set_Temperature_Heating_Storage(k=
        T_HeatingWater_set)
    annotation (Placement(transformation(extent={{-14,82},{-24,92}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{-48,52},{-38,62}})));
  Modelica.Blocks.Sources.Constant min_Temperature_WasteWater(k=
        T_WasteWater_upper_min)
    annotation (Placement(transformation(extent={{-68,42},{-58,52}})));
  Modelica.Blocks.Logical.And and3
    annotation (Placement(transformation(extent={{-24,58},{-34,72}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-6,60},{-16,72}})));
initial equation
time_cleaning_start = 0;
cleaning_finished=true;
iscleaning=false;
bypass_forced_opened_value=false;
bypass_forced_closed_value=false;
V_WasteWater = 0;
equation
  V_storage=Modelica.Constants.pi * d_storage^2/4*h_storage;

  // Calculation of release time (Torricelli)  --  0.1 =^d_outlet
 t_releasing = integer((d_storage/0.1)^2*(2*h_storage/Modelica.Constants.g_n*(1-(0.1/d_storage)^4))^0.5);
 t_cleaning_end = time_cleaning_start + t_releasing +  t_cleaning;

//   ////////////////////////////////////////////////// Heatpump control
//   //  if lowest temperature in heatingstorage is lower than a specified max temperature and  wastewater temperature is high enough and no cleaning is in procedure than set heatingpump on
//  if T_WasteWaterStorage[n_WasteWater_layers]>T_WasteWater_upper_min and T_HeatingWaterStorage[n_HeatingWater_layers-5]<T_HeatingWater_lower_max and not iscleaning then
//                                                                       /**/
//    HP_ison=true;
//  else
//    HP_ison=false;
//  end if;

  ////////////////////////////////////////////////// Evaporator and condensor pump control

if HP_ison then
  dot_m_cond_pump = dot_m_cond_pump_fix;
  dot_m_evap_pump = dot_m_evap_pump_fix;
else
  dot_m_cond_pump = 0;
  dot_m_evap_pump = 0;
end if;

   // iniate cleaning if conditions are ok
   when wastewatermassFlowRate.dotm/(rho_WasteWater * V_storage) > 1/6000 and not (pre(iscleaning)) and s_biofilm>s_biofilm_max then
        /**/
        /*T_HeatingWaterStorage[10] > T_HeatingWater_min_cleaning and*/

                                                                                                                                                       /*and  wastewatertemperature.T > T_WasteWater_min_cleaning*/
                                                                                /**/
   iscleaning =true;
   time_cleaning_start=time;
   // reinitialize after cleaning is done
  reinit( V_WasteWater,0);
elsewhen pre(cleaning_finished) then
  iscleaning=false;
  time_cleaning_start=0;
  reinit( V_WasteWater,0);
end when;

    // cleaning procedure itself
  when iscleaning and time <= t_cleaning_end then
    //first release wastewater from tank and clean (fixed time) and hold bypass opened
   // if  then
      cleaning_finished=false;
      der(V_WasteWater)=0;
      bypass_forced_opened_value=true;
      bypass_forced_closed_value=false;
     // biofilm_removing=true;

     // after releasing wastewater and cleaning: start refill and hold bypass closed
  elsewhen iscleaning and time >t_cleaning_end  and V_WasteWater < V_storage then
     bypass_forced_opened_value= false;
     //biofilm_removing=false;
         cleaning_finished=false;
         der(V_WasteWater) = wastewatermassFlowRate.dotm/rho_WasteWater;
         bypass_forced_closed_value=true;

     // after refill go back to normal operation mode
  elsewhen iscleaning and V_WasteWater >=V_storage then
         bypass_forced_opened_value= false;
         //biofilm_removing=false;
         cleaning_finished=true;
         der(V_WasteWater)=0;
         bypass_forced_closed_value=false;
         //reinit(V_WasteWater,0);

 end when;



  connect(const.y, switch1.u1) annotation (Line(points={{89.5,-25},{78.4,-25},{78.4,
          -37.6}}, color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{66.6,-56},{72,-56},{72,
          -50},{76,-50},{76,-50.4},{78.4,-50.4}},
                                color={0,0,127}));
  connect(switch1.y, threeWayValve.opening) annotation (Line(points={{96.8,-44},
          {94,-44},{94,-68},{9,-68}},          color={0,0,127}));
  connect(threeWayValve.enthalpyPort_a, WW_control_out_storage)
    annotation (Line(points={{0,-78},{0,-98}}, color={176,0,0}));
  connect(threeWayValve.enthalpyPort_b, WW_control_out_bypass) annotation (Line(
        points={{-10,-68},{-38,-68},{-66,-68},{-66,-98}}, color={176,0,0}));
  connect(wastewatertemperature.enthalpyPort_b, threeWayValve.enthalpyPort_ab)
    annotation (Line(points={{-4.1,-9},{-4.1,-17.5},{1.77636e-015,-17.5},{1.77636e-015,
          -58.2}}, color={176,0,0}));
  connect(wastewatertemperature.T, less.u1)
    annotation (Line(points={{7,-1},{7,-42},{16.8,-42}},    color={0,0,127}));
  connect(WW_control_in, wastewatermassFlowRate.enthalpyPort_a)
    annotation (Line(points={{0,98},{-0.1,98},{-0.1,50.8}}, color={176,0,0}));
  connect(wastewatermassFlowRate.enthalpyPort_b, wastewatertemperature.enthalpyPort_a)
    annotation (Line(points={{-0.1,33},{-0.1,33},{-0.1,8.8},{-4.1,8.8}},
                                                                 color={176,0,0}));
  connect(bypass_forced_closed.y, nor.u2) annotation (Line(points={{33,-32},{34,
          -32},{34,-34.8},{36.8,-34.8}}, color={255,0,255}));
  connect(less.y, and2.u2) annotation (Line(points={{30.6,-42},{44,-42},{44,-43},
          {55,-43}}, color={255,0,255}));
  connect(nor.y, and2.u1) annotation (Line(points={{50.6,-30},{54,-30},{54,-39},
          {55,-39}}, color={255,0,255}));
  connect(and2.y, or1.u2) annotation (Line(points={{66.5,-39},{66.5,-20},{62,-20},
          {62,-13},{71,-13}}, color={255,0,255}));
  connect(or1.y, switch1.u2) annotation (Line(points={{82.5,-9},{86,-9},{86,-22},
          {76,-22},{76,-44},{78.4,-44}}, color={255,0,255}));
  connect(bypass_forced_opened.y, nor.u1) annotation (Line(points={{35,-8},{36,-8},
          {36,-30},{36.8,-30}}, color={255,0,255}));
  connect(bypass_forced_opened.y, or1.u1) annotation (Line(points={{35,-8},{52,-8},
          {52,-9},{71,-9}}, color={255,0,255}));
  connect(set_Temperature_Heating_Storage.y, onOffController.reference)
    annotation (Line(points={{-24.5,87},{-28.25,87},{-28.25,89.2},{-32.6,89.2}},
        color={0,0,127}));
  connect(onOffController.y, and1.u1) annotation (Line(points={{-48.7,85},{-48.7,
          93},{-60.6,93}}, color={255,0,255}));
  connect(min_Temperature_WasteWater.y, greater.u2) annotation (Line(points={{-57.5,
          47},{-53.75,47},{-53.75,53},{-49,53}}, color={0,0,127}));
  connect(and1.y, HP_ison) annotation (Line(points={{-76.7,93},{-89.35,93},{-89.35,
          96},{-110,96}}, color={255,0,255}));
  connect(T_WasteWaterStorage[1], less.u2) annotation (Line(points={{-104,37.6},
          {-104,48},{-82,48},{-82,-46.8},{16.8,-46.8}}, color={0,0,127}));
  connect(T_HeatingWaterStorage[8], onOffController.u) annotation (Line(points={
          {-104,79.5},{-32.6,79.5},{-32.6,80.8}}, color={0,0,127}));
  connect(greater.y, and3.u2) annotation (Line(points={{-37.5,57},{-23,57},{-23,
          59.4}}, color={255,0,255}));
  connect(and3.u1, not1.y) annotation (Line(points={{-23,65},{-19.5,65},{-19.5,66},
          {-16.5,66}}, color={255,0,255}));
  connect(not1.u, iscleaning) annotation (Line(points={{-5,66},{8,66},{8,64},{116,
          64},{116,-72},{46,-72},{46,-106},{50,-106}}, color={255,0,255}));
  connect(and3.y, and1.u2) annotation (Line(points={{-34.5,65},{-60.6,65},{-60.6,
          87.4}}, color={255,0,255}));
  connect(T_WasteWaterStorage[10], greater.u1) annotation (Line(points={{-104,
          66.4},{-76,66.4},{-76,57},{-49,57}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end WasteWaterStorageControl;
