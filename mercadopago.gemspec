# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mercadopago/version"

Gem::Specification.new do |s|
  s.name        = "mercadopago"
  s.version     = MercadoPago::VERSION
  s.authors     = ["Kauplus Social Commerce", "Ombu Shop, Tu Tienda Online"]
  s.email       = ["suporte@kauplus.com.br"]
  s.homepage    = "https://github.com/kauplus/mercadopago"
  s.summary     = %q{Client for the MercadoPago API}
  s.description = %q{Esta gem é um cliente que permite que desenvolvedores acessem os serviços do http://www.mercadopago.com (MercadoPago)}

  s.rubyforge_project = "mercadopago"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here:
  s.add_dependency 'json', '>= 1.4.6'
  s.add_dependency 'rest-client', '1.6.7'
  s.add_development_dependency 'pry'
end
