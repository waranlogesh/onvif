defmodule Onvif.Media.Ver10.GetProfiles do
  import SweetXml
  import XmlBuilder

  def soap_action, do: "http://www.onvif.org/ver10/media/wsdl/GetProfiles"

  def request(uri, auth \\ :no_auth),
    do: Onvif.Media.Ver10.Media.request(uri, [], auth, __MODULE__)

  def request_body do
    element(:"s:Body", [element(:"trt:GetProfiles")])
  end

  def response(xml_response_body) do
    xml_response_body
    |> parse(namespace_conformant: true, quiet: true)
    |> xpath(
      ~x"//s:Envelope/s:Body/trt:GetProfilesResponse/trt:Profiles"el
      |> add_namespace("s", "http://www.w3.org/2003/05/soap-envelope")
      |> add_namespace("trt", "http://www.onvif.org/ver10/media/wsdl")
      |> add_namespace("tt", "http://www.onvif.org/ver10/schema")
    )
    |> Enum.map(&Onvif.Media.Ver10.Profile.parse/1)
    |> Enum.map(&Onvif.Media.Ver10.Profile.to_struct/1)
  end
end
