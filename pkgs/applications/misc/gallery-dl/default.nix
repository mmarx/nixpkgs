{
  lib,
  buildPythonApplication,
  fetchPypi,
  requests,
  yt-dlp,
  pytestCheckHook,
}:

buildPythonApplication rec {
  pname = "gallery-dl";
  version = "1.27.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "gallery_dl";
    hash = "sha256-S1RF0FNJ/oKTwq9SXXIOnqBIViGIYBVuxPjV/6fbeV8=";
  };

  propagatedBuildInputs = [
    requests
    yt-dlp
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"

    # incompatible with pytestCheckHook
    "--ignore=test/test_ytdl.py"
  ];

  pythonImportsCheck = [ "gallery_dl" ];

  meta = {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    changelog = "https://github.com/mikf/gallery-dl/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    mainProgram = "gallery-dl";
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}
