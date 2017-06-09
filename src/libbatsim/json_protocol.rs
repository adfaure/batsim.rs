extern crate serde_json;

#[derive(Debug, Serialize, Deserialize)]
pub struct Job {
    pub id: String,
    pub res: i32,
    pub profile: String,
    pub subtime: f64,
    pub walltime: f64,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum Profile {
    #[serde(rename = "delay")]
    Delay { delay: f64 },
    #[serde(rename = "msg_par_hg")]
    MsgParHg { com: f64, cpu: f64 },
}

#[derive(Debug, Serialize, Deserialize)]
pub struct BatsimMessage {
    pub now: f64,
    pub events: Vec<BatsimEvent>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct SubmitJob {
    pub job_id: String,
    pub job: Job,
    pub profile: Option<Profile>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Notify {
    #[serde(rename = "type")]
    pub notify_type: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct JobSubmitted {
    pub job_id: String,
    pub job: Job,
    pub profile: Option<Profile>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct RejectJob {
    pub job_id: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ExecuteJob {
    pub job_id: String,
    pub alloc: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct KillJob {
    pub job_ids: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct JobKilled {
    pub job_ids: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct JobCompleted {
    pub job_id: String,
    pub status: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct SimulationBegins {
    pub config: serde_json::Value,
    pub nb_resources: i32,
}

#[allow(non_camel_case_types)]
#[derive(Debug, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum BatsimEvent {
    ///From batsim to sched
    SIMULATION_BEGINS {
        timestamp: f64,
        data: SimulationBegins,
    },
    JOB_SUBMITTED { timestamp: f64, data: JobSubmitted },
    SIMULATION_ENDS { timestamp: f64 },
    JOB_COMPLETED { timestamp: f64, data: JobCompleted },
    JOB_KILLED { timestamp: f64, data: JobKilled },

    /// From sched to batsim
    EXECUTE_JOB { timestamp: f64, data: ExecuteJob },
    REJECT_JOB { timestamp: f64, data: RejectJob },
    KILL_JOB { timestamp: f64, data: KillJob },

    /// Dynamic submit feature
    SUBMIT_JOB { timestamp: f64, data: SubmitJob },
    NOTIFY { timestamp: f64, data: Notify },
}
