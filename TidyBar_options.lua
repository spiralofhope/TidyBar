--  Understanding the screen width and bars
--  This is Blizzard's choice
local space_between_buttons = 6
local half_of_screen = GetScreenWidth() / 2

local position_left = ( -1 * ( GetScreenWidth() / 2 ) ) + space_between_buttons

local number_of_buttons = 12
local position_right = ( ActionButton1:GetWidth() * number_of_buttons ) + ( space_between_buttons * ( number_of_buttons - 1 ) )
local position_right = half_of_screen - position_right - space_between_buttons



do  --  Default options
  TidyBar_options = {}

  TidyBar_options.show_StatusTrackingBarManager = true
  TidyBar_options.always_show_corner = true
  TidyBar_options.always_show_side = true
  TidyBar_options.show_macro_text = false
  TidyBar_options.main_area_positioning = position_left + position_right + position_right

  TidyBar_options.show_textured_background_petbattle = false

  TidyBar_options.debug = false
end



function TidyBar_setup_options_pane()


TidyBar = {}
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
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.always_show_side', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Always show the side bars' )
  --CheckButton.tooltipText = 'Auto-hide the right-hand vertical bars on MouseOut.'
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
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.always_show_corner', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Always show the corner bars' )
  --CheckButton.tooltipText = 'When enabled, auto-hide the bottom-left buttons and bags on MouseOut.'
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
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_StatusTrackingBarManager', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show Status Tracking Bar' )
  CheckButton.tooltipText = 'The combined experience/etc bar, at the bottom.  Note that this cannot be changed in combat.'
  CheckButton:SetChecked( TidyBar_options.show_StatusTrackingBarManager )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.show_StatusTrackingBarManager = true
    else
      TidyBar_options.show_StatusTrackingBarManager = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_macro_text
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_macro_text', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show macro text' )
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



do  --  TidyBar_options.show_textured_background_petbattle
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_textured_background_petbattle', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show pet battle background' )
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


space()



do  --  TidyBar_options.main_area_positioning
  position = position + 1
  local main_area_positioning_slider
  main_area_positioning_slider = CreateFrame( 'Slider', 'TidyBar_options.main_area_positioning', TidyBar_options_panel_frame, 'OptionsSliderTemplate' )
  main_area_positioning_slider:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( main_area_positioning_slider:GetName() .. 'Text' ):SetText( 'Main area positioning' )
  main_area_positioning_slider.tooltipText = 'The position of the main area.'
  main_area_positioning_slider:SetMinMaxValues( position_left, position_right )
  main_area_positioning_slider:SetValueStep( 1 )
  main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
  main_area_positioning_slider:SetScript( 'OnValueChanged', function()
    TidyBar_options.main_area_positioning = main_area_positioning_slider:GetValue()
    TidyBar_refresh_everything()
    -- Show the corner while positioning the main area.
    MicroButtonAndBagsBar:SetAlpha( 1 )
    if TidyBar_options.debug then
      print( 'TidyBar_options.main_area_positioning ' .. TidyBar_options.main_area_positioning )
    end
  end)


  position = position + 1
  local Button
  Button = CreateFrame( 'Button', 'TidyBar_options.main_area_positioning2', TidyBar_options_panel_frame, 'OptionsButtonTemplate' )
  Button:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
  Button.tooltipText = 'Reset the main area positioning to the middle.'
  Button:SetScript( 'OnClick', function( self )
    TidyBar_options.main_area_positioning = position_left + position_right + position_right
    main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
    TidyBar_refresh_everything()
  end)
end



space()



space()



do  --  TidyBar_options.debug
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.debug', TidyBar_options_panel_frame, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show debug messages' )
  CheckButton.tooltipText = ''
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

end
