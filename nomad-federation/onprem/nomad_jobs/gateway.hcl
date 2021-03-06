job "gateway-onprem" {
    datacenters = ["onprem"]
    region = "onprem"

    type = "service"

    group "gateways" {
        count = 1

        network {
            mode = "bridge"

            port "https" {
                static = 443
                to = 443
            }
        }

        constraint {
            operator  = "distinct_hosts"
            value     = "true"
        }

        task "gateway" {
            driver = "docker"

            env {
                CONSUL_HTTP_ADDR="10.5.0.100:8500"
                CONSUL_GRPC_ADDR="10.5.0.100:8502"
            }

            config {
                image = "nicholasjackson/consul-envoy:v1.7.2-v0.14.1"
                command = "consul"
                args    = [
                    "connect", "envoy",
                    "-mesh-gateway",
                    "-register",
                    "-wan-address", "192.168.5.100:443",
                    "--",
                    "-l", "debug"
                ]
            }
        }
    }
}