defmodule InnoTest.RssParserTest do
  use ExUnit.Case
  alias InnoTest.RssParser

  @valid_rss """
             <?xml version="1.0" encoding="UTF-8" ?>
             <rss version="2.0">

             <channel>
               <title>W3Schools Home Page</title>
               <link>https://www.w3schools.com</link>
               <description>Free web building tutorials</description>
               <item>
                 <title>RSS Tutorial</title>
                 <link>https://www.w3schools.com/xml/xml_rss.asp</link>
                 <description>New RSS tutorial on W3Schools</description>
               </item>
               <item>
                 <title>XML Tutorial</title>
                 <link>https://www.w3schools.com/xml</link>
                 <description>New XML tutorial on W3Schools</description>
               </item>
             </channel>

             </rss>
             """

  @invalid_rss "random text"

  defp valid_result(_) do
    {:ok, RssParser.parse(@valid_rss, 1)}
  end

  defp invalid_result(_) do
    {:ok, RssParser.parse(@invalid_rss)}
  end

  describe "Valid example" do
    setup [:valid_result]

    test "Title", %{title: title} do
      assert title == "W3Schools Home Page"
    end

    test "Items count is limited", %{items: items} do
      assert length(items) == 1
    end

    test "Item title", %{items: [item]} do
      assert item.title == "RSS Tutorial"
    end
  end

  describe "Invalid example" do
    setup [:invalid_result]

    test "error message", %{error: error} do
      assert error == "Parsing error"
    end
  end
end
