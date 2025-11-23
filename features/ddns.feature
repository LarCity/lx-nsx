Feature: Nsx
  In order to keep my domain updated with my dynamic IP address
  As a Ddns
  I want to be able to send DDNS updates via a dockerized ddclient service on a Synology NAS device

  Scenario: Update DDNS via ddclient Docker on Synology NAS
    Given a YAML config file named "spec/tmp/lar_city/ddns/active.yml" with:
      """yml
      shared:
        - domain: larcity.tech
          content: mario
          type: A
          ttl: 300
        - domain: larcity.business
          content: luigi
          type: A
          ttl: 300
      """
    Given a YAML config file named "spec/tmp/lar_city/ddns/retired.yml" with:
      """yml
      shared:
        - domain: larcity.dev
          content: retired
          type: A
          ttl: 300
        - domain: larcity.business
          content: deprecated
          type: A
          ttl: 300
      """
    When I successfully run `lx-nsx ddns update --protocol=digitalocean --config=lar_city/ddns/active.yml --verbose --pretend`
    Then the output should contain "Synchronizing DDNS records..."

  Scenario: Update DDNS via ddclient Docker on Synology NAS with detected configuration
    Given a file named "lib/config/ddns/active.yml" with:
      """yml
      shared:
        - domain: larcity.dev
          content: alpha
          type: A
          ttl: 300
        - domain: larcity.business
          content: beta
          type: A
          ttl: 300
      """
    And a file named "lib/config/ddns/retired.yml" with:
      """yml
      shared:
        - domain: larcity.dev
          content: retired
          type: A
          ttl: 300
        - domain: larcity.business
          content: deprecated
          type: A
          ttl: 300
      """
    When I successfully run `lx-nsx ddns update --protocol=digitalocean --verbose --pretend`
    Then the output should contain "Synchronizing DDNS records..."
