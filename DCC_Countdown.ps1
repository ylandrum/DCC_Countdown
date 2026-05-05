# Dungeon Crawler Carl - "A Parade of Horribles" Countdown Timer
# Release Date: May 12, 2026

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ReleaseDate = [datetime]"2026-05-12 00:00:00"

# == Main Form ==================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text           = "Dungeon Crawler Carl - A Parade of Horribles"
$form.Size           = New-Object System.Drawing.Size(620, 420)
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
    $g.DrawString("A Parade of Horribles  *  Book 8", $fontSub, $brushSub, 57, 46)
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
    # Border
    $pen = New-Object System.Drawing.Pen($cBorder, 1)
    $g.DrawRectangle($pen, 0, 0, 579, 179)
    $pen.Dispose()
    # Corner accents
    $penG = New-Object System.Drawing.Pen($cGold, 2)
    foreach ($x in @(0, 559)) {
        foreach ($y in @(0, 159)) {
            $g.DrawLine($penG, $x, $y, $x+20, $y)
            $g.DrawLine($penG, $x, $y, $x, $y+20)
        }
    }
    $penG.Dispose()
})
$form.Controls.Add($countPanel)

# == Unit blocks: Days / Hours / Minutes / Seconds =============================
$units = @(
    @{ Label="DAYS";    X=30  },
    @{ Label="HOURS";   X=170 },
    @{ Label="MINUTES"; X=310 },
    @{ Label="SECONDS"; X=450 }
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

    # Separator (except last)
    if ($u.Label -ne "SECONDS") {
        $sep = New-Object System.Windows.Forms.Label
        $sep.Text      = ":"
        $sep.Font      = New-Object System.Drawing.Font("Consolas", 30, [System.Drawing.FontStyle]::Bold)
        $sep.ForeColor = $cOrange
        $sep.BackColor = [System.Drawing.Color]::Transparent
        $sep.Size      = New-Object System.Drawing.Size(20, 80)
        $sep.Location  = New-Object System.Drawing.Point(([int]$u.X + 120), 36)
        $sep.TextAlign = "MiddleCenter"
        $countPanel.Controls.Add($sep)
    }

    $valueLabels[$u.Label] = $val
}

# == Progress bar area =========================================================
$progressPanel = New-Object System.Windows.Forms.Panel
$progressPanel.Size     = New-Object System.Drawing.Size(580, 22)
$progressPanel.Location = New-Object System.Drawing.Point(20, 300)
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

    # Track
    $brushTrack = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30,25,45))
    $g.FillRectangle($brushTrack, 2, 4, 576, 14)
    $brushTrack.Dispose()

    # Fill gradient
    if ($filled -gt 0) {
        $fillRect = New-Object System.Drawing.Rectangle(2, 4, $filled, 14)
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
    $g.DrawRectangle($pen, 2, 4, 576, 14)
    $pen.Dispose()

    # Percent text
    $pctText = "{0:N1}% of the wait is over" -f ($pct * 1000)
    $brushTxt = New-Object System.Drawing.SolidBrush($cWhite)
    $g.DrawString($pctText, $fontSmall, $brushTxt, 4, 2)
    $brushTxt.Dispose()
})
$form.Controls.Add($progressPanel)

# == Flavor text ===============================================================
$flavorLines = @(
    '"The dungeon waits for no one." - Carl, probably',
    '"Stay alive long enough to read it." - Donut, definitely',
    '"Every second counts. The apocalypse is scheduled." - Matt Dinniman',
    '"The System has calculated your patience level: insufficient." - Floor Boss',
    '"Hold on. Level up. Read the book." - Crawler wisdom'
)
$flavor = $flavorLines[(Get-Random -Maximum $flavorLines.Count)]

$flavorLabel = New-Object System.Windows.Forms.Label
$flavorLabel.Text      = $flavor
$flavorLabel.Font      = $fontFooter
$flavorLabel.ForeColor = $cDim
$flavorLabel.BackColor = $cBg
$flavorLabel.Size      = New-Object System.Drawing.Size(580, 22)
$flavorLabel.Location  = New-Object System.Drawing.Point(20, 330)
$flavorLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($flavorLabel)

# == Footer bar ================================================================
$footerPanel = New-Object System.Windows.Forms.Panel
$footerPanel.Size      = New-Object System.Drawing.Size(620, 36)
$footerPanel.Location  = New-Object System.Drawing.Point(0, 358)
$footerPanel.BackColor = [System.Drawing.Color]::FromArgb(16, 10, 30)

$footerPanel.Add_Paint({
    param($s, $e)
    $g = $e.Graphics
    $pen = New-Object System.Drawing.Pen($cBorder, 1)
    $g.DrawLine($pen, 0, 0, 620, 0)
    $pen.Dispose()
    $brushTxt = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80,60,30))
    $g.DrawString("  ***  DUNGEON CRAWLER CARL  *  Matt Dinniman  *  May 12, 2026  ***", $fontSmall, $brushTxt, 80, 10)
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
    } else {
        $days    = [int][Math]::Floor($span.TotalDays)
        $hours   = $span.Hours
        $minutes = $span.Minutes
        $seconds = $span.Seconds

        $valueLabels["DAYS"].Text    = "{0:D2}" -f $days
        $valueLabels["HOURS"].Text   = "{0:D2}" -f $hours
        $valueLabels["MINUTES"].Text = "{0:D2}" -f $minutes
        $valueLabels["SECONDS"].Text = "{0:D2}" -f $seconds

        # Pulse seconds orange when under a minute
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

# SIG # Begin signature block
# MIIH8gYJKoZIhvcNAQcCoIIH4zCCB98CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBrM5vLj0hRT0G4
# kiCIUgD/THaZ6GUI4yf9fVm/JmHc8qCCBUMwggU/MIIEJ6ADAgECAhMWAAB5VCcE
# B2Uza1iGAAQAAHlUMA0GCSqGSIb3DQEBCwUAMDwxEzARBgoJkiaJk/IsZAEZFgNv
# cmcxFDASBgoJkiaJk/IsZAEZFgRvc2xhMQ8wDQYDVQQDEwZvc2xhMDEwHhcNMjYw
# NTA1MTczMjU1WhcNMjcwNzExMjIwOTUyWjCBmTETMBEGCgmSJomT8ixkARkWA29y
# ZzEUMBIGCgmSJomT8ixkARkWBG9zbGExHDAaBgNVBAsTE0FjY291bnRzIGFuZCBH
# cm91cHMxFDASBgNVBAsTC0RlcGFydG1lbnRzMR8wHQYDVQQLExZJbmZvcm1hdGlv
# biBUZWNobm9sb2d5MRcwFQYDVQQDEw5ZYW5jZXkgTGFuZHJ1bTCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBAJhul/nOvx9+i9jd0wQxTBhXpb7p0WNnAWLs
# 0Yg2hHq9wzofl+EtsMJzOp8yqy1xG0Uh/w4JqYksBUl3pg4l3hvKxWOsEHnPDh3n
# 07Mo/STxX0AQg2hT26UqL5ObmCiQ92DfZlUlrChnCL3KvNyBBMNJet7OkFV5flSF
# F9eDMwSfDA+k+UmKnVEyc/75QdwRF4mll08t3dQUKPUhWDz23F8qC/klaM0kokYn
# k6mTEKYrnd8iDQV4nHqJaZ0UvC/QwzhyeFpDHno1Sq37VnOiPwyuimVbrIR+oFWm
# SojUSOoby+8WzwwIQgadoq4d/cetZl4Z8Kj2LbVYy5qaVMuHDkECAwEAAaOCAdow
# ggHWMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCITR1AiE+d0/gemTHIXy7ySB
# +7o9L4Kq0XPRjDYCAWQCAQMwEwYDVR0lBAwwCgYIKwYBBQUHAwMwCwYDVR0PBAQD
# AgeAMBsGCSsGAQQBgjcVCgQOMAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFKGh2I6d
# QZmNX/v129xIqMhzBNkkMB8GA1UdIwQYMBaAFF4fQ/q9riYZNzBHa5c0GeTPl7d/
# MEAGA1UdHwQ5MDcwNaAzoDGGL2h0dHA6Ly9PU0xBMDEub3NsYS5vcmcvQ2VydEVu
# cm9sbC9vc2xhMDEoMykuY3JsMFsGCCsGAQUFBwEBBE8wTTBLBggrBgEFBQcwAoY/
# aHR0cDovL09TTEEwMS5vc2xhLm9yZy9DZXJ0RW5yb2xsL09TTEEwMS5vc2xhLm9y
# Z19vc2xhMDEoNCkuY3J0MCoGA1UdEQQjMCGgHwYKKwYBBAGCNxQCA6ARDA95YW5j
# ZXlAb3NsYS5vcmcwTAYJKwYBBAGCNxkCBD8wPaA7BgorBgEEAYI3GQIBoC0EK1Mt
# MS01LTIxLTM1OTI3MDMwLTE2NzI1MDU2NDItMzMxNjQzMTA2LTE3NzYwDQYJKoZI
# hvcNAQELBQADggEBAHj8la7ImHXQZw9yQaKfDl85L+HgfboSfsw85/ohp6cWzYGE
# zcOhXyyN3nSU/3Dx1jdw6alYkOWPcxl3LC5MmXYYNBCO+8X+ngoGDIOvc+Fo9e/j
# D2ZfNYlleN1N+x9g9LezKsrVOlkqWp+BKuK0V2xWX8uUl5bJrjE4fv8sm1MKSEUu
# 5LeIs3Do2WrmaiifJdLenpqIztdv0VyYx71T+mELvsoM4G48eZMwkSJr/07rsALd
# unj1Z2KnQE0viw5oRabvmbwqDD2bZt2rUkD1T7uNdpHpkPhkP8lWkkY7zCXQ4jk0
# yS9krTebXi4YHK1O3BP6AhgNP2gLKgy9hk7hlz4xggIFMIICAQIBATBTMDwxEzAR
# BgoJkiaJk/IsZAEZFgNvcmcxFDASBgoJkiaJk/IsZAEZFgRvc2xhMQ8wDQYDVQQD
# EwZvc2xhMDECExYAAHlUJwQHZTNrWIYABAAAeVQwDQYJYIZIAWUDBAIBBQCggYQw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQx
# IgQgZNYAj5uMP3g824CF9IhKxDESuN5TkWTw0bQzWKWdgh0wDQYJKoZIhvcNAQEB
# BQAEggEAl0yFf/9/3smNS7ueoJg1awgz43v9rGqaNkQ1fTgbjyeH+A0pD8EqhpWv
# VS9gWgZW5R2Qyoch5qu+e3aJJ1ESjGEOEoZQQG9kHz8EuX9CUQedNsu85qdcCcej
# UbSA0q8z/7ZF5ed1GpHBnaqWfd3HqL0j6Wgi8JNG2+x40LUt7PqPxZSOfUkvJGjp
# aTEYMWyjgO97ZMSD1rF5e7ko//+Y/WbS/tpwgjDY8GpYQ07Ca55umLFSlBiASIi0
# PfE7tu1behhds+Jn8dv41Yip5ceY04/BXYyxDXxJmq8+uhE/oySgC0Yutu+RARvW
# maJTWNyreXc/xeQ+pbDMF0OuRsXd6Q==
# SIG # End signature block
