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
  stdenv,
  toml,
  writeText,
}:

let
  fido2' = fido2.overridePythonAttrs (old: {
    doCheck = (old.doCheck or true) && !stdenv.isDarwin;
    pythonImportsCheck = lib.optionals (!stdenv.isDarwin) (old.pythonImportsCheck or [ ]);
  });
in
buildPythonPackage rec {
  pname = "aws-adfs";
  version = "3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = "${
    fetchGit {
      name = "aws-adfs-${version}";
      url = "git@git.eu.clara.net:de-cloud-tooling/aws/aws_saml_token.git";
      ref = "refs/tags/${version}";
      rev = "6ff503790a4af611eb8b4fb51ac359636c19bf65";
    }
  }/aws-adfs";

  build-system = [
    poetry-core
  ];

  patches = lib.optionals stdenv.isDarwin [
    (writeText "lazy-fido2-imports.patch" ''
      diff --git a/aws_adfs/_duo_authenticator.py b/aws_adfs/_duo_authenticator.py
      --- a/aws_adfs/_duo_authenticator.py
      +++ b/aws_adfs/_duo_authenticator.py
      @@ -3,8 +3,8 @@ import binascii
       import click
       import lxml.etree as ET

      -from fido2.client import ClientError, Fido2Client
      -from fido2.hid import CtapHidDevice
      +Fido2Client = None
      +CtapHidDevice = None
       try:
           from fido2.pcsc import CtapPcscDevice
       except ImportError:
      @@ -305,6 +305,11 @@ def _verify_authentication_status(duo_host, sid, duo_transaction_id, session,

                   webauthn_session_id = webauthn_credential_request_options.pop('sessionId')

      +            global Fido2Client, CtapHidDevice
      +            if CtapHidDevice is None:
      +                from fido2.client import Fido2Client
      +                from fido2.hid import CtapHidDevice
      +
                   devices = list(CtapHidDevice.list_devices())
                   if CtapPcscDevice:
                       devices.extend(list(CtapPcscDevice.list_devices()))
      diff --git a/aws_adfs/_duo_universal_prompt_authenticator.py b/aws_adfs/_duo_universal_prompt_authenticator.py
      --- a/aws_adfs/_duo_universal_prompt_authenticator.py
      +++ b/aws_adfs/_duo_universal_prompt_authenticator.py
      @@ -3,8 +3,8 @@ import binascii
       import click
       import lxml.etree as ET

      -from fido2.client import ClientError, Fido2Client
      -from fido2.hid import CtapHidDevice
      +Fido2Client = None
      +CtapHidDevice = None
       from fido2.utils import websafe_decode, websafe_encode

       try:
      @@ -423,6 +423,11 @@ def _verify_authentication_status(duo_host, sid, duo_transaction_id, session,

                   webauthn_session_id = webauthn_credential_request_options.pop("sessionId")

      +            global Fido2Client, CtapHidDevice
      +            if CtapHidDevice is None:
      +                from fido2.client import Fido2Client
      +                from fido2.hid import CtapHidDevice
      +
                   devices = list(CtapHidDevice.list_devices())
                   if CtapPcscDevice:
                       devices.extend(list(CtapPcscDevice.list_devices()))
    '')
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
    fido2'
    lxml
    pyopenssl
    requests
    requests-kerberos
  ];

  nativeCheckInputs = [
    pytestCheckHook
    toml
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = lib.optionals (!stdenv.isDarwin) [ "aws_adfs" ];

  meta = {
    description = "Command line tool to ease AWS CLI authentication against ADFS";
    homepage = "https://github.com/venth/aws-adfs";
    changelog = "https://github.com/venth/aws-adfs/releases/tag/${src.tag}";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ bhipple ];
    mainProgram = "aws-adfs";
  };
}
