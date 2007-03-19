class Quran::StructureController < QuranController

  def index
      self.heading = "Structure of the Qur'an"
      @quran_struct = quran_struct
  end

end
