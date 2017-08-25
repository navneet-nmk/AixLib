within AixLib.Fluid.Examples.GeothermalHeatPump.Components;
model GeothermalHeatPump
  "Component model of the geothermal heat pump example with connectors"
  extends
    AixLib.Fluid.Examples.GeothermalHeatPump.BaseClasses.GeothermalHeatPumpControlledBase(
  redeclare AixLib.Fluid.Examples.GeothermalHeatPump.Components.BoilerExternalControl PeakLoadDevice(redeclare
        package Medium =                                                                                          Medium));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_consumerCold(redeclare package
      Medium = Medium) "Port to cold consumers" annotation (Placement(
        transformation(extent={{150,-30},{170,-10}}), iconTransformation(extent={{-170,30},
            {-150,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_consumerHeat(redeclare package
      Medium = Medium) "Port to heat consumers" annotation (Placement(
        transformation(extent={{150,-60},{170,-40}}), iconTransformation(extent={{148,30},
            {168,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_consumerCold(redeclare package
      Medium = Medium) "Port from cold consumer" annotation (Placement(
        transformation(extent={{150,22},{170,42}}), iconTransformation(extent={{-170,
            -72},{-150,-52}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_consumerHeat(redeclare package
      Medium = Medium) "Port from heat consumer" annotation (Placement(
        transformation(extent={{150,-116},{170,-96}}), iconTransformation(
          extent={{150,-70},{170,-50}})));
  Control.PumpControlBus pumpControlBus
    annotation (Placement(transformation(extent={{40,60},{82,98}})));
  Modelica.Blocks.Interfaces.RealOutput TStorageUpper(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0,
    displayUnit="degC") "Temperature of upper heat storage layer" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,90})));
  Modelica.Blocks.Interfaces.RealOutput TStorageLower(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0,
    displayUnit="degC") "Temperature of lower cold storage layer" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,90})));
  Controls.Interfaces.BoilerControlBus boilerControlBus
    annotation (Placement(transformation(extent={{90,60},{132,98}})));
  Control.ValveControlBus valveControlBus
    annotation (Placement(transformation(extent={{-72,58},{-30,100}})));
equation
  connect(resistanceColdConsumerReturn.port_a, port_a_consumerCold)
    annotation (Line(points={{94,32},{160,32}}, color={0,127,255}));
  connect(resistanceColdConsumerFlow.port_b, port_b_consumerCold)
    annotation (Line(points={{94,-20},{160,-20}}, color={0,127,255}));
  connect(PeakLoadDevice.port_b, port_b_consumerHeat)
    annotation (Line(points={{120,-50},{160,-50}}, color={0,127,255}));
  connect(resistanceHeatConsumerReturn.port_a, port_a_consumerHeat)
    annotation (Line(points={{94,-106},{160,-106}}, color={0,127,255}));
  connect(pumpGeothermalSource.dp_in, pumpControlBus.p_pumpGeothermalSource)
    annotation (Line(points={{-89.14,-45.6},{-89.14,-38},{16,-38},{16,60},{
          61.105,60},{61.105,79.095}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(pumpCondenser.dp_in, pumpControlBus.p_pumpCondenser) annotation (Line(
        points={{-0.86,-89.6},{-0.86,-60},{16,-60},{16,60},{61.105,60},{61.105,
          79.095}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(pumpEvaporator.dp_in, pumpControlBus.p_pumpEvaporator) annotation (
      Line(points={{7.14,44.4},{7.14,60},{61.105,60},{61.105,79.095}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(pumpColdConsumer.dp_in, pumpControlBus.p_pumpColdConsumer)
    annotation (Line(points={{64.86,-11.6},{64.86,52},{61.105,52},{61.105,
          79.095}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(pumpHeatConsumer.dp_in, pumpControlBus.p_pumpHeatConsumer)
    annotation (Line(points={{64.86,-41.6},{64.86,-34},{54,-34},{54,52},{61.105,
          52},{61.105,79.095}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(getTStorageUpper.y, TStorageUpper)
    annotation (Line(points={{-139,68},{-100,68},{-100,90}}, color={0,0,127}));
  connect(valveColdStorage.y_actual, valveControlBus.feedback_valveColdStorage)
    annotation (Line(points={{-55,42.9},{-56,42.9},{-56,44},{-56,44},{-56,62},{
          -50.895,62},{-50.895,79.105}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(getTStorageLower.y, TStorageLower) annotation (Line(points={{-139,52},
          {-88,52},{-88,66},{-80,66},{-80,90}}, color={0,0,127}));
  connect(PeakLoadDevice.boilerControlBus, boilerControlBus) annotation (Line(
      points={{114,-44.06},{114,66},{111,66},{111,79}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(chemicalEnergyFlowRate, boilerControlBus.chemicalEnergyFlowRate)
    annotation (Line(points={{-71.5,-119.5},{-71.5,-92},{-28,-92},{-28,-114},{
          104,-114},{104,66},{111.105,66},{111.105,79.095}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(valveColdStorage.y, valveControlBus.opening_valveColdStorage)
    annotation (Line(points={{-52,46.4},{-52,62},{-52,79.105},{-50.895,79.105}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(valveHeatSource.y, valveControlBus.opening_valveHeatSource)
    annotation (Line(points={{-68.4,1},{-74,1},{-74,52},{-50.895,52},{-50.895,
          79.105}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(valveHeatSource.y_actual, valveControlBus.feedback_valveHeatSource)
    annotation (Line(points={{-64.9,4},{-66,4},{-66,62},{-50.895,62},{-50.895,
          79.105}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(valveHeatSink.y, valveControlBus.opening_valveHeatSink) annotation (
      Line(points={{-30,-45.6},{-30,-28},{-66,-28},{-66,62},{-50.895,62},{
          -50.895,79.105}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(valveHeatSink.y_actual, valveControlBus.feedback_valveHeatSink)
    annotation (Line(points={{-27,-49.1},{-26,-49.1},{-26,-26},{-68,-26},{-68,
          62},{-50.895,62},{-50.895,79.105}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(valveHeatStorage.y, valveControlBus.opening_valveHeatStorage)
    annotation (Line(points={{-26.4,-63},{-38,-63},{-38,-28},{-66,-28},{-66,62},
          {-50.895,62},{-50.895,79.105}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(valveHeatStorage.y_actual, valveControlBus.feedback_valveHeatStorage)
    annotation (Line(points={{-22.9,-60},{-22,-60},{-22,-26},{-66,-26},{-66,62},
          {-50.895,62},{-50.895,79.105}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 19, 2017, by Marc Baranski:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; font-size: 10pt;\">Information</span></b> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Overview</span></b> </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple component model of a combined heat and cold supply system. The geothermal heat pump can either transport heat </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- from the cold to the heat storage</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- from the cold storage to the geothermal field (heat storage disconnected)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- from the geothermal field to the heat storage</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">In the flow line of the heating circuit a boiler is connected as a peak load device. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Consumers are modeled as sinks are sources with a constant temperature.</span></p>
</html>"));
end GeothermalHeatPump;