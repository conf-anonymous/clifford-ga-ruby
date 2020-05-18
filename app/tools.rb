module Clifford
  class Tools

    def self.random_number(bits)
      rng = Random.new
      rng.rand(((2**(bits-1))+1)..((2**bits)-1))
    end

    def self.generate_regular_keys
      k = []

      2.times do
        while true
          mk = generate_random_multivector

          if mk.gp(mk.inverse).data == [1,0,0,0,0,0,0,0]
            k << mk
            break
          end
        end
      end

      k
    end

    def self.generate_modular_keys
      k = Array.new(2){ generate_random_modular_multivector }
    end

    def self.generate_random_multivector
      Clifford::Multivector3D.new Array.new(8){ random_number(8) }
    end

    def self.generate_random_modular_multivector
      m1_10 = random_number(8)
      m2_10 = random_number(8)
      d = Clifford::Multivector3D.new [
        Rational(m1_10 + m2_10,2), 0, Rational(m1_10 - m2_10,2),0,0,0,0,0
      ]
      Clifford::Packing.a.gp(d).gp(Clifford::Packing.a.inverse)
    end

    def self.mod(m1,m2)
      a = Clifford::Packing.a

      d1 = a.inverse.gp(m1).gp(a)
      d2 = a.inverse.gp(m2).gp(a)

      d = Clifford::Multivector3D.new [(d1.e0 % (d2.e0 - d2.e2)),0,(d1.e2 % (d2.e0 - d2.e2)),0,0,0,0,0]

      a.gp(d).gp(a.inverse)
    end

  end
end
