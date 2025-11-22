Feature: Ddns
  In order to keep my domain updated with my dynamic IP address
  As a CLI
  I want to be able to send DDNS updates via a dockerized ddclient service on a Synology NAS device

  Scenario: Update DDNS via ddclient Docker on Synology NAS
    Given I have a Synology NAS device with Docker installed
    And I have a domain name registered with a DDNS provider
    And I have created a ddclient configuration file with my DDNS provider credentials
    When I run `ddns sync --config config/ddns/active.yml --pretend`
    Then the output should contain "Done!"
