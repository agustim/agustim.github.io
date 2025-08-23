# Network Namespace

* Crear un namespace

```ip netns add <ns_nom>```

* Crear un veth pair (parell d'ethernet virtual)

```ip link add veth_host type veth peer name veth_ns```

* Assignar el parell al netns

```ip link set veth_ns netns <ns_name>```

* Assignar un ip el veth pair al ns

```ip netns exec <ns_name> ip addr add 10.0.0.2/24 dev veth_ns
ip netns exec <ns_name> ip link set veth_ns up
ip netns exec <ns_name> ip link set lo up```

* Assignar una ip al veth pair del host

```ip addr add 10.0.0.1/24 dev veth0
ip link set veth0 up```

* Definir la ruta per defecte al ns

ip netns exec example ip route add default via 10.0.0.1

* Definr el host per que faci masquerade, forwarding amb el ns i forward entre paquets.

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o <interficie_host_default> -j MASQUERADE
iptables -A FORWARD -i veth_host -o <interficie_host_default> -j ACCEPT
iptables -A FORWARD -i <interficie_host_default> -o veth_host -m state --state RELATED,ESTABLISHED -j ACCEPT





 

