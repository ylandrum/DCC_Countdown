# Dungeon Crawler Carl - "A Parade of Horribles" Countdown Timer
# Release Date: May 12, 2026

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ReleaseDate = [datetime]"2026-05-12 00:00:00"

# == Main Form ==================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text           = "Dungeon Crawler Carl - A Parade of Horribles"
$form.Size           = New-Object System.Drawing.Size(635, 430)
$form.StartPosition  = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox    = $false
$form.BackColor      = [System.Drawing.Color]::FromArgb(10, 8, 18)
$form.Icon           = [System.Drawing.SystemIcons]::Application

# == Helper: font loader (fallback-safe) =======================================
function Get-Font($families, $size, $style = "Regular") {
    foreach ($f in $families) {
        try {
            $font = New-Object System.Drawing.Font($f, $size, [System.Drawing.FontStyle]$style)
            if ($font.Name -eq $f) { return $font }
        } catch {}
    }
    return New-Object System.Drawing.Font("Courier New", $size, [System.Drawing.FontStyle]$style)
}

# == Colors ====================================================================
$cGold    = [System.Drawing.Color]::FromArgb(255, 185,  80)
$cOrange  = [System.Drawing.Color]::FromArgb(255, 110,  30)
$cDim     = [System.Drawing.Color]::FromArgb(130,  90,  30)
$cBlue    = [System.Drawing.Color]::FromArgb( 80, 160, 255)
$cBg      = [System.Drawing.Color]::FromArgb( 10,   8,  18)
$cPanel   = [System.Drawing.Color]::FromArgb( 22,  16,  36)
$cBorder  = [System.Drawing.Color]::FromArgb( 80,  50,  10)
$cWhite   = [System.Drawing.Color]::FromArgb(220, 210, 190)

# == Fonts =====================================================================
$fontTitle  = Get-Font @("Palatino Linotype","Palatino","Georgia","Times New Roman") 18 "Bold"
$fontSub    = Get-Font @("Palatino Linotype","Georgia","Times New Roman") 10 "Italic"
$fontLabel  = Get-Font @("Consolas","Courier New","Lucida Console") 8 "Bold"
$fontBig    = Get-Font @("Consolas","Courier New","Lucida Console") 36 "Bold"
$fontSmall  = Get-Font @("Consolas","Courier New","Lucida Console") 9 "Regular"
$fontFooter = Get-Font @("Palatino Linotype","Georgia","Times New Roman") 9 "Italic"

# == Title Panel (painted) =====================================================
$titlePanel = New-Object System.Windows.Forms.Panel
$titlePanel.Size     = New-Object System.Drawing.Size(620, 90)
$titlePanel.Location = New-Object System.Drawing.Point(0, 0)
$titlePanel.BackColor = $cBg

$titlePanel.Add_Paint({
    param($s, $e)
    $g = $e.Graphics
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Background gradient
    $rect = New-Object System.Drawing.Rectangle(0, 0, 620, 90)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(30, 20, 5),
        [System.Drawing.Color]::FromArgb(10, 8, 18),
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $g.FillRectangle($brush, $rect)
    $brush.Dispose()

    # Bottom border line
    $pen = New-Object System.Drawing.Pen($cBorder, 2)
    $g.DrawLine($pen, 0, 88, 620, 88)
    $pen.Dispose()

    # Decorative corner marks
    $penGold = New-Object System.Drawing.Pen($cGold, 1)
    $g.DrawLine($penGold,  20, 10,  20, 30)
    $g.DrawLine($penGold,  10, 10,  30, 10)
    $g.DrawLine($penGold, 600, 10, 600, 30)
    $g.DrawLine($penGold, 590, 10, 610, 10)
    $penGold.Dispose()

    # Icon dot
    $brushGold = New-Object System.Drawing.SolidBrush($cGold)
    $g.FillEllipse($brushGold, 28, 28, 14, 14)
    $brushGold.Dispose()
    $brushOrange = New-Object System.Drawing.SolidBrush($cOrange)
    $g.FillEllipse($brushOrange, 31, 31, 8, 8)
    $brushOrange.Dispose()

    # Main title
    $brushTitle = New-Object System.Drawing.SolidBrush($cGold)
    $g.DrawString("DUNGEON CRAWLER CARL", $fontTitle, $brushTitle, 55, 12)
    $brushTitle.Dispose()

    # Subtitle
    $brushSub = New-Object System.Drawing.SolidBrush($cOrange)
    $g.DrawString("A Parade of Horribles  * Book 8", $fontSub, $brushSub, 57, 46)
    $brushSub.Dispose()

    # Release line
    $brushDim = New-Object System.Drawing.SolidBrush($cDim)
    $g.DrawString("RELEASES  MAY 12, 2026", $fontLabel, $brushDim, 57, 68)
    $brushDim.Dispose()
})
$form.Controls.Add($titlePanel)

# == Countdown Panel ===========================================================
$countPanel = New-Object System.Windows.Forms.Panel
$countPanel.Size      = New-Object System.Drawing.Size(580, 180)
$countPanel.Location  = New-Object System.Drawing.Point(20, 105)
$countPanel.BackColor = $cPanel
$countPanel.BorderStyle = "None"

$countPanel.Add_Paint({
    param($s, $e)
    $g = $e.Graphics
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    
    # Border
    $pen = New-Object System.Drawing.Pen($cBorder, 1)
    $g.DrawRectangle($pen, 0, 0, 579, 179)
    $pen.Dispose()
    
    # Corner accents (Corrected orientation)
    $penG = New-Object System.Drawing.Pen($cGold, 2)
    # Top-Left
    $g.DrawLine($penG, 0, 0, 20, 0)
    $g.DrawLine($penG, 0, 0, 0, 20)
    # Top-Right
    $g.DrawLine($penG, 579, 0, 559, 0)
    $g.DrawLine($penG, 579, 0, 579, 20)
    # Bottom-Left
    $g.DrawLine($penG, 0, 179, 20, 179)
    $g.DrawLine($penG, 0, 179, 0, 159)
    # Bottom-Right
    $g.DrawLine($penG, 579, 179, 559, 179)
    $g.DrawLine($penG, 579, 179, 579, 159)
    $penG.Dispose()

    # Draw Separator Colons directly to avoid label clipping (Shifted left by 10)
    $brushColons = New-Object System.Drawing.SolidBrush($cOrange)
    $fontColons  = New-Object System.Drawing.Font("Consolas", 30, [System.Drawing.FontStyle]::Bold)
    $g.DrawString(":", $fontColons, $brushColons, 136, 42)
    $g.DrawString(":", $fontColons, $brushColons, 276, 42)
    $g.DrawString(":", $fontColons, $brushColons, 416, 42)
    $brushColons.Dispose()
    $fontColons.Dispose()
})
$form.Controls.Add($countPanel)

# == Unit blocks: Days / Hours / Minutes / Seconds =============================
# Shifted X values left by 10 to perfectly center within the 580px wide panel
$units = @(
    @{ Label="DAYS";    X=20  },
    @{ Label="HOURS";   X=160 },
    @{ Label="MINUTES"; X=300 },
    @{ Label="SECONDS"; X=440 }
)

$valueLabels = @{}

foreach ($u in $units) {
    # Label
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text      = $u.Label
    $lbl.Font      = $fontLabel
    $lbl.ForeColor = $cDim
    $lbl.BackColor = [System.Drawing.Color]::Transparent
    $lbl.Size      = New-Object System.Drawing.Size(120, 16)
    $lbl.Location  = New-Object System.Drawing.Point($u.X, 18)
    $lbl.TextAlign = "MiddleCenter"
    $countPanel.Controls.Add($lbl)

    # Value
    $val = New-Object System.Windows.Forms.Label
    $val.Text      = "00"
    $val.Font      = $fontBig
    $val.ForeColor = $cGold
    $val.BackColor = [System.Drawing.Color]::Transparent
    $val.Size      = New-Object System.Drawing.Size(120, 80)
    $val.Location  = New-Object System.Drawing.Point($u.X, 36)
    $val.TextAlign = "MiddleCenter"
    $countPanel.Controls.Add($val)

    $valueLabels[$u.Label] = $val
}

# == Progress bar area =========================================================
$progressPanel = New-Object System.Windows.Forms.Panel
# Height increased from 22 to 28, moved up slightly to point 295
$progressPanel.Size     = New-Object System.Drawing.Size(580, 28)
$progressPanel.Location = New-Object System.Drawing.Point(20, 295)
$progressPanel.BackColor = [System.Drawing.Color]::FromArgb(15, 10, 25)

# Total span from announcement date to release
$AnnounceDate = [datetime]"2025-09-01"
$totalSpan    = ($ReleaseDate - $AnnounceDate).TotalSeconds

$progressPanel.Add_Paint({
    param($s, $e)
    $g = $e.Graphics
    $now     = [datetime]::Now
    $elapsed = ($now - $AnnounceDate).TotalSeconds
    $pct     = [Math]::Max(0, [Math]::Min(1, $elapsed / $totalSpan))
    $filled  = [int]($pct * 576)

    # Track (Thickness increased)
    $brushTrack = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30,25,45))
    $g.FillRectangle($brushTrack, 2, 2, 576, 24)
    $brushTrack.Dispose()

    # Fill gradient
    if ($filled -gt 0) {
        $fillRect = New-Object System.Drawing.Rectangle(2, 2, $filled, 24)
        $brushFill = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $fillRect,
            $cOrange,
            $cGold,
            [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
        )
        $g.FillRectangle($brushFill, $fillRect)
        $brushFill.Dispose()
    }

    # Border
    $pen = New-Object System.Drawing.Pen($cBorder, 1)
    $g.DrawRectangle($pen, 2, 2, 576, 24)
    $pen.Dispose()

    # Percent text vertically centered
    $pctText = "{0:N3}% of the wait is over" -f ($pct * 100)
    $brushTxt = New-Object System.Drawing.SolidBrush($cWhite)
    $g.DrawString($pctText, $fontSmall, $brushTxt, 10, 6)
    $brushTxt.Dispose()
})
$form.Controls.Add($progressPanel)

# == Flavor text ===============================================================
$flavorLines = @(
    '"Stay alive long enough to read it." - Donut, definitely',
    '"Every second counts. The apocalypse is scheduled." - Matt Dinniman',
    '"The System has calculated your patience level: insufficient." - Floor Boss',
    '"Hold on. Level up. Read the book." - Crawler wisdom',
    '"Goddammit, Donut!" - Carl, a lot',
    '"You will not break me. Fuck you all. You will not break me." - Carl, repeatedly',
    '"Your creature crapped in my mother''s ashes. This is so not worth it. Not worth it at all." - Mordecai, definitely',
    '"Glurp on that, motherfucker." - Carl, obviously'  
)
$flavor = $flavorLines[(Get-Random -Maximum $flavorLines.Count)]

$flavorLabel = New-Object System.Windows.Forms.Label
$flavorLabel.Text      = $flavor
$flavorLabel.Font      = $fontFooter
$flavorLabel.ForeColor = $cDim
$flavorLabel.BackColor = $cBg
$flavorLabel.Size      = New-Object System.Drawing.Size(580, 22)
$flavorLabel.Location  = New-Object System.Drawing.Point(20, 332)
$flavorLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($flavorLabel)

# == Footer bar ================================================================
$footerPanel = New-Object System.Windows.Forms.Panel
$footerPanel.Size      = New-Object System.Drawing.Size(620, 36)
$footerPanel.Location  = New-Object System.Drawing.Point(0, 360)
$footerPanel.BackColor = [System.Drawing.Color]::FromArgb(16, 10, 30)

$footerPanel.Add_Paint({
    param($s, $e)
    $g = $e.Graphics
    $pen = New-Object System.Drawing.Pen($cBorder, 1)
    $g.DrawLine($pen, 0, 0, 620, 0)
    $pen.Dispose()
    $brushTxt = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80,60,30))
    $g.DrawString("  *** DUNGEON CRAWLER CARL  * Matt Dinniman  * May 12, 2026  ***", $fontSmall, $brushTxt, 80, 10)
    $brushTxt.Dispose()
})
$form.Controls.Add($footerPanel)

# == Ticker: update every second ===============================================
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000

$timer.Add_Tick({
    $now  = [datetime]::Now
    $span = $ReleaseDate - $now

    if ($span.TotalSeconds -le 0) {
        $valueLabels["DAYS"].Text    = "00"
        $valueLabels["HOURS"].Text   = "00"
        $valueLabels["MINUTES"].Text = "00"
        $valueLabels["SECONDS"].Text = "00"
        $valueLabels["DAYS"].ForeColor    = $cBlue
        $valueLabels["HOURS"].ForeColor   = $cBlue
        $valueLabels["MINUTES"].ForeColor = $cBlue
        $valueLabels["SECONDS"].ForeColor = $cBlue
        $flavorLabel.Text      = "*** A PARADE OF HORRIBLES IS OUT NOW - GO READ IT! ***"
        $flavorLabel.ForeColor = $cGold
        
        $progressPanel.Invalidate()
        $timer.Stop()
    } else {
        $days    = [int][Math]::Floor($span.TotalDays)
        $hours   = $span.Hours
        $minutes = $span.Minutes
        $seconds = $span.Seconds

        $valueLabels["DAYS"].Text    = "{0:D2}" -f $days
        $valueLabels["HOURS"].Text   = "{0:D2}" -f $hours
        $valueLabels["MINUTES"].Text = "{0:D2}" -f $minutes
        $valueLabels["SECONDS"].Text = "{0:D2}" -f $seconds

        if ($days -eq 0 -and $hours -eq 0 -and $minutes -eq 0) {
            $valueLabels["SECONDS"].ForeColor = $cOrange
        } else {
            $valueLabels["SECONDS"].ForeColor = $cGold
        }
    }

    $progressPanel.Invalidate()
})

$timer.Start()
$form.Add_FormClosed({ $timer.Stop(); $timer.Dispose() })

# == Launch ====================================================================
[System.Windows.Forms.Application]::Run($form)
