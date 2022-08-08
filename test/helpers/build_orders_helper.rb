module BuildOrdersHelper

  def build_orders
    [
      OpenStruct.new(ship_no: "000108", recipient: "陳漢強"),
      OpenStruct.new(ship_no: "000107", recipient: "李若芸")
    ]
  end

end
