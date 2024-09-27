{
  inputs = {
    grml-small-amd64 = {
      url = "https://download.grml.org/grml-small-2024.12-amd64.iso";
      flake = false;
    };
    nixoot.url = "github:shymega/Nixoot";
  };

  outputs = inputs: {
    config = {
      isoPath = inputs.grml-small-amd64;
    };
  };
}
