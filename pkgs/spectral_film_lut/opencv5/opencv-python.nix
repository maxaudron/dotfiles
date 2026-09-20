{
  mkPythonMetaPackage,
  opencv5,
}:

mkPythonMetaPackage {
  pname = "opencv-python";
  version = "5.0.0.93";
  dependencies = [ opencv5 ];
  optional-dependencies = opencv5.optional-dependencies or { };
  meta = {
    inherit (opencv5.meta) description homepage;
  };
}
