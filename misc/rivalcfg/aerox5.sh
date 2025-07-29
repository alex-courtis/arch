#!/bin/sh

rivalcfg --reset

rivalcfg --default-lighting off

rivalcfg --sensitivity "250,500,750"

rivalcfg -b "buttons(button1=button1; button2=button2; button3=button3; button4=button4; button5=button5; button6=dpi; button7=right; button8=left; button9=up; scrollup=scrollup; scrolldown=scrolldown; layout=qwerty)"
