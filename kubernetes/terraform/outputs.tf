output "kuber_ip" {
  value = yandex_compute_instance.kuber[*].network_interface.0.nat_ip_address
}

resource "local_file" "AnsibleInventory" {
 content = templatefile("inventory.tmpl",
 {
  kuber_ip = yandex_compute_instance.kuber[*].network_interface.0.nat_ip_address,
 }
 )
 filename = "../ansible/inventory.sh"
}
