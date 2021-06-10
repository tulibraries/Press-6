module AgenciesHelper
  def rights_coverage(region)
    case region
    when "Turkey", "Spanish & Portuguese languages, World"
      "Exclusive Rights"
    else
      "Non-exclusive Rights"
    end
  end
end
