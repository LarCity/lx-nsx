Feature: Nsx
  In order to keep my domain updated with my dynamic IP address
  As a Ddns
  I want to be able to send DDNS updates via a dockerized ddclient service on a Synology NAS device

  Scenario: Update DDNS via ddclient Docker on Synology NAS
    When I run `lx-nsx ddns:update --config config/ddns/active.yml --pretend`
    Then the output should contain "Done!"
