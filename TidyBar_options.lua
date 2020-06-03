function TidyBar_setup_options_pane()
--  Called by Tidybar_main.lua during its initialization.

local Button
local CheckButton

--  Understanding the screen width and bars
--  This is Blizzard's choice
local space_between_buttons = 6
local half_of_screen_width = GetScreenWidth() / 2

--local maximum_position_left = ( -1 * ( GetScreenWidth() / 2 ) ) + space_between_buttons
local maximum_position_left = space_between_buttons

local number_of_buttons = 12
--local maximum_position_right = ( ActionButton1:GetWidth() * number_of_buttons ) + ( space_between_buttons * ( number_of_buttons - 1 ) )
--local maximum_position_right = half_of_screen_width - maximum_position_right - space_between_buttons
local maximum_position_right = ( GetScreenWidth() - ( ActionButton1:GetWidth() * number_of_buttons ) - ( space_between_buttons * ( number_of_buttons - 1 ) ) )

local maximum_position_bottom = -4
--  TODO - less the height of all the other things.
local maximum_position_top    = ( GetScreenHeight() - ActionButton1:GetHeight() )

local position_top = GetScreenHeight()
local position_bottom = 0


do  --  Default options
  if TidyBar_options                                    == nil then   TidyBar_options                                    =   {}                                                       end
  if TidyBar_options.show_StatusTrackingBarManager      == nil then   TidyBar_options.show_StatusTrackingBarManager      =   false                                                    end
  if TidyBar_options.always_show_corner                 == nil then   TidyBar_options.always_show_corner                 =   false                                                    end
  if TidyBar_options.always_show_side                   == nil then   TidyBar_options.always_show_side                   =   false                                                    end
  if TidyBar_options.show_macro_text                    == nil then   TidyBar_options.show_macro_text                    =   false                                                    end
  if TidyBar_options.main_area_positioning_x            == nil then   TidyBar_options.main_area_positioning_x            =   maximum_position_left + ( maximum_position_right * 2 )   end
  if TidyBar_options.main_area_positioning_y            == nil then   TidyBar_options.main_area_positioning_y            =   0                                                        end
  if TidyBar_options.bags_area_positioning_x            == nil then   TidyBar_options.bags_area_positioning_x            =   3                                                        end
-- fixme
  if TidyBar_options.bags_area_positioning_y            == nil then   TidyBar_options.bags_area_positioning_y            =   0                                                        end
  if TidyBar_options.debug                              == nil then   TidyBar_options.debug                              =   false                                                    end

  if release_type == 'retail' then
  if TidyBar_options.show_textured_background_petbattle == nil then   TidyBar_options.show_textured_background_petbattle =   false                                                    end
  end

end



TidyBar_options_panel = CreateFrame( 'Frame', 'TidyBar_options_panel_frame', UIParent )
TidyBar_options_panel.name = 'TidyBar'
InterfaceOptions_AddCategory( TidyBar_options_panel )

local position = 0

local function space()
  position = position + 1
  Text = TidyBar_options_panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
  Text:SetPoint( 'TopLeft', 20, -25  )
  Text:SetText( '' )
end



position = position + 1
Text = TidyBar_options_panel:CreateFontString( nil, UIParent, 'GameFontNormal' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( 'TidyBar - Version ' .. GetAddOnMetadata( 'TidyBar', 'Version' ) )



position = position + 1
Text = TidyBar_options_panel:CreateFontString( nil, UIParent, 'GameFontNormal' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( GetAddOnMetadata( 'TidyBar', 'Notes' ) )



position = position + 1
Text = TidyBar_options_panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( 'With great thanks to danltiger for the original TidyBar.' )



space()



space()



do  --  TidyBar_options.always_show_side
  position = position + 1
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.always_show_side', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ CheckButton:GetName() .. 'Text' ]:SetText( 'Always show the side bars' )
  --CheckButton.tooltipText = ''
  CheckButton:SetChecked( TidyBar_options.always_show_side )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.always_show_side = true
    else
      TidyBar_options.always_show_side = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.always_show_corner
  position = position + 1
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.always_show_corner', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ CheckButton:GetName() .. 'Text' ]:SetText( 'Always show the corner bars' )
  --CheckButton.tooltipText = ''
  CheckButton:SetChecked( TidyBar_options.always_show_corner )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.always_show_corner = true
    else
      TidyBar_options.always_show_corner = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_StatusTrackingBarManager
  position = position + 1
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_StatusTrackingBarManager', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ CheckButton:GetName() .. 'Text' ]:SetText( 'Show Status Tracking Bar' )
  CheckButton.tooltipText = 'The combined experience/etc bar, at the bottom.  Note that this cannot be changed in combat.'
  CheckButton:SetChecked( TidyBar_options.show_StatusTrackingBarManager )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.show_StatusTrackingBarManager = true
      print( 'TidyBar:  NOTE - This is bugged.  See issue #67' )
    else
      TidyBar_options.show_StatusTrackingBarManager = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_macro_text
  position = position + 1
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_macro_text', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ CheckButton:GetName() .. 'Text' ]:SetText( 'Show macro text' )
  CheckButton.tooltipText = 'For any macros dragged out into any bar, show its name.'
  CheckButton:SetChecked( TidyBar_options.show_macro_text )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.show_macro_text = true
    else
      TidyBar_options.show_macro_text = false
    end
    TidyBar_refresh_everything()
  end)
end



if release_type == 'retail' then
  do  --  TidyBar_options.show_textured_background_petbattle
    position = position + 1
    CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_textured_background_petbattle', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
    CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
    _G[ CheckButton:GetName() .. 'Text' ]:SetText( 'Show pet battle background' )
    CheckButton.tooltipText = 'Show the background behind the pet battle UI.'
    CheckButton:SetChecked( TidyBar_options.show_textured_background_petbattle )
    CheckButton:SetScript( 'OnClick', function( self )
      if self:GetChecked() then
        TidyBar_options.show_textured_background_petbattle = true
      else
        TidyBar_options.show_textured_background_petbattle = false
      end
      TidyBar_refresh_everything()
    end)
  end
end

space()


do  --  TidyBar_options.main_area_positioning_x
  position = position + 1
  local main_area_positioning_slider_x
  main_area_positioning_slider_x = CreateFrame( 'Slider', 'TidyBar_options.main_area_positioning_x', TidyBar_options_panel_frame, 'OptionsSliderTemplate' )
  main_area_positioning_slider_x:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ main_area_positioning_slider_x:GetName() .. 'Text' ]:SetText( 'Main area positioning (x)' )
  main_area_positioning_slider_x.tooltipText = 'The position of the main area (left/right).'
  main_area_positioning_slider_x:SetMinMaxValues( maximum_position_left, maximum_position_right )
  main_area_positioning_slider_x:SetValueStep( 1 )
  main_area_positioning_slider_x:SetValue( TidyBar_options.main_area_positioning_x )
  main_area_positioning_slider_x:SetScript( 'OnValueChanged', function()
    TidyBar_options.main_area_positioning_x = main_area_positioning_slider_x:GetValue()
    TidyBar_refresh_everything()
    -- Show the corner while positioning the main area.
    MicroButtonAndBagsBar:SetAlpha( 1 )
    if TidyBar_options.debug then
      print( 'TidyBar_options.main_area_positioning_x ' .. TidyBar_options.main_area_positioning_x )
    end
  end)


  position = position + 1
  Button = CreateFrame( 'Button', 'TidyBar_options.main_area_positioning_x2', TidyBar_options_panel_frame, 'OptionsButtonTemplate' )
  Button:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ Button:GetName() .. 'Text' ]:SetText( 'Reset' )
  Button.tooltipText = 'Reset the main area positioning to the middle.'
  Button:SetScript( 'OnClick', function( self )
    --TidyBar_options.main_area_positioning_x = maximum_position_left + maximum_position_right + maximum_position_right
    TidyBar_options.main_area_positioning_x = maximum_position_left + maximum_position_right
    main_area_positioning_slider_x:SetValue( TidyBar_options.main_area_positioning_x )
    TidyBar_refresh_everything()
  end)
end



space()


do  --  TidyBar_options.main_area_positioning_y

  position = position + 1
  local main_area_positioning_slider_y
  main_area_positioning_slider_y = CreateFrame( 'Slider', 'TidyBar_options.main_area_positioning_y', TidyBar_options_panel_frame, 'OptionsSliderTemplate' )
  main_area_positioning_slider_y:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ main_area_positioning_slider_y:GetName() .. 'Text' ]:SetText( 'Main area positioning (y)' )
  main_area_positioning_slider_y.tooltipText = 'The position of the main area (top/bottom).'
  main_area_positioning_slider_y:SetMinMaxValues( maximum_position_bottom, maximum_position_top )
  main_area_positioning_slider_y:SetValueStep( 1 )
  main_area_positioning_slider_y:SetValue( TidyBar_options.main_area_positioning_y )
  main_area_positioning_slider_y:SetScript( 'OnValueChanged', function()
    TidyBar_options.main_area_positioning_y = main_area_positioning_slider_y:GetValue()
    TidyBar_refresh_everything()
    -- Show the corner while positioning the main area.
    MicroButtonAndBagsBar:SetAlpha( 1 )
    if TidyBar_options.debug then
      print( 'TidyBar_options.main_area_positioning_y ' .. TidyBar_options.main_area_positioning_y )
    end
  end)


  position = position + 1
  Button = CreateFrame( 'Button', 'TidyBar_options.main_area_positioning_y2', TidyBar_options_panel_frame, 'OptionsButtonTemplate' )
  Button:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ Button:GetName() .. 'Text' ]:SetText( 'Reset' )
  Button.tooltipText = 'Reset the main area positioning to the bottom.'
  Button:SetScript( 'OnClick', function( self )
    TidyBar_options.main_area_positioning_y = 0
    main_area_positioning_slider_y:SetValue( TidyBar_options.main_area_positioning_y )
    TidyBar_refresh_everything()
  end)
end



space()



space()



do  --  TidyBar_options.debug
  position = position + 1
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.debug', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  _G[ CheckButton:GetName() .. 'Text' ]:SetText( 'Show debug messages' )
  --CheckButton.tooltipText = ''
  CheckButton:SetChecked( TidyBar_options.debug )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      print( 'TidyBar:  Debugging enabled' )
      TidyBar_options.debug = true
    else
      print( 'TidyBar:  Debugging disabled' )
      TidyBar_options.debug = false
    end
    --TidyBar_refresh_everything()
  end)
end

end  --  TidyBar_setup_options_pane()
