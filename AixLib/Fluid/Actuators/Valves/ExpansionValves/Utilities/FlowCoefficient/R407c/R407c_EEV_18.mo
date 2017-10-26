within AixLib.Fluid.Actuators.Valves.ExpansionValves.Utilities.FlowCoefficient.R407c;
model R407c_EEV_18
  "Polynomial - R407c - EEV - 1.8 mm"
  extends PolynomialFlowCoefficient(
    final polyMod=Choices.PolynomialModels.Li2013,
    final a={-0.07154,1.67713,-0.79141,1.09516,0,0},
    final b={1,1,1,1,1,1},
    final pDifRat=0.84);

  annotation (Documentation(revisions="<html>
<ul>
  <li>
  October 16, 2017, by Mirko Engelpracht:<br/>
  First implementation
  (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/457\">issue 457</a>).
  </li>
</ul>
</html>"));
end R407c_EEV_18;