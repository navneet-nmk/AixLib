within AixLib.Fluid.Movers.Compressors.Utilities.VolumetricEfficiency.ReciporatingCompressors.SimilitudeTheory;
model Buck_R134aR450aR1234yfR1234zee_Reciporating
  "Power - Similtude for R134a, R450a, R1234yf, R1234ze(e) - Reciporating"
  extends PowerVolumetricEfficiency(
    final MRef=0.102032,
    final rotSpeRef=9.334,
    final powMod=Choices.VolumetricPowerModels.MendozaMirandaEtAl2016,
    final a=1,
    final b={-0.2678,-0.0106,0.7195});

end Buck_R134aR450aR1234yfR1234zee_Reciporating;