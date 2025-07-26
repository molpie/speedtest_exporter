// Copyright (C) 2016, 2017 Nicolas Lamirault <nicolas.lamirault@gmail.com>

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package version

import (
    "github.com/prometheus/client_golang/prometheus"
    prom_version "github.com/prometheus/common/version"
)

// Version represents the application version using SemVer
const Version string = "0.3.0"

var buildInfo = prometheus.NewGaugeVec(
    prometheus.GaugeOpts{
        Name: "speedtest_exporter_build_info",
        Help: "Speedtest exporter build information",
    },
    []string{"version", "revision", "branch", "buildUser", "buildDate"},
)

func VersionCollector() prometheus.Collector {
    buildInfo.WithLabelValues(
        Version,                        // tua costante personalizzata
        prom_version.Revision,
        prom_version.Branch,
        prom_version.BuildUser,
        prom_version.BuildDate,
    ).Set(1)
    return buildInfo
}
