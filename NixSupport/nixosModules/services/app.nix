{ config, pkgs, modulesPath, lib, self, ... }:
let
    cfg = config.services.ihp;
in
{
    systemd.services.app = {
        description = "IHP App";
        enable = true;
        after = [ "network.target" "app-keygen.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            Type = "simple";
            Restart = "always";
            WorkingDirectory = "${cfg.package}/lib";
            ExecStart = "${cfg.package}/bin/RunProdServer";
        };
        environment =
            let
                defaultEnv = {
                    PORT = "${toString cfg.appPort}";
                    IHP_ENV = cfg.ihpEnv;
                    IHP_BASEURL = cfg.baseUrl;
                    IHP_REQUEST_LOGGER_IP_ADDR_SOURCE = cfg.requestLoggerIPAddrSource;
                    DATABASE_URL = cfg.databaseUrl;
                    IHP_SESSION_SECRET_FILE = cfg.sessionSecretFile;
                    GHCRTS = cfg.rtsFlags;
                };
            in
                defaultEnv // cfg.additionalEnvVars;
    };
}