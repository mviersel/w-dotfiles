#Requires AutoHotkey v2.0
SetCapsLockState "AlwaysOff"

; --- RAlt layer (alleen rechter Alt) ---
RAlt & k::Send "{Up}"
RAlt & h::Send "{Left}"
RAlt & j::Send "{Down}"
RAlt & l::Send "{Right}"
RAlt & n::Send "{Home}"
RAlt & m::Send "{End}"


; CapsLock: tap = Esc, hold = LCtrl
CapsLock:: {
    releasedInTime := KeyWait("CapsLock", "T0.10")  ; 1 = released, 0 = timeout (still held)

    if releasedInTime {
        ; snel losgelaten -> tap
        Send "{Esc}"
    } else {
        ; nog ingedrukt na 180ms -> hold
        Send "{Blind}{LCtrl down}"
        KeyWait "CapsLock"          ; wacht tot je loslaat
        Send "{Blind}{LCtrl up}"
    }
}

; --- Insert -> Media Play/Pause ---
Insert::Media_Play_Pause
