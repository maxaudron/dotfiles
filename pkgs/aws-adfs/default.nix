{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  click,
  configparser,
  fido2,
  lxml,
  poetry-core,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-kerberos,
  toml,
}:

buildPythonPackage rec {
  pname = "aws-adfs";
  version = "2.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = ./aws-adfs.tar.gz;

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "configparser"
    "fido2"
    "lxml"
    "requests-kerberos"
  ];

  dependencies = [
    boto3
    botocore
    click
    configparser
    fido2
    lxml
    pyopenssl
    requests
    requests-kerberos
  ];

  nativeCheckInputs = [
    pytestCheckHook
    toml
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "aws_adfs" ];

  meta = {
    description = "Command line tool to ease AWS CLI authentication against ADFS";
    homepage = "https://github.com/venth/aws-adfs";
    changelog = "https://github.com/venth/aws-adfs/releases/tag/${src.tag}";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ bhipple ];
    mainProgram = "aws-adfs";
  };
}
