class profile::elk_server {
  include elk
  elk::node { 'elk.local': }
}
