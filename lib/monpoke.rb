class Monpoke
  attr_accessor :id, :hp, :ap

  def initialize(id, hp, ap)
    if ((hp.to_i < 1) || (ap.to_i < 1))
      abort("Monpoke must start with at least 1 hp & ap")
    end

    @id = id
    @hp = hp.to_i
    @ap = ap.to_i
  end

  def alive?
    return (hp > 0)
  end
end
