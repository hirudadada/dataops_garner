# frozen_string_literal: true

module Ingestion
  class Action < Garner::Action
    include Deps['job']
    include Deps['messages.fetch_job_logs_message'] # callback: handle_fetched_job_logs

    # def schedule_next
    #   job.next_batch
    #   # while batches is not maxed out
    #   if job.max_batches_reached?
    #     logger.info "[Job##{job.name}] Ingestion job is completed"
    #   else
    #     fetch_job_logs_message.deliver!(limit: job.batch_size)
    #     logger.info "[Batch##{job.batch_name}] Scheduled next batch for ingestion job"
    #     # logger.info("Collecting #{job.batch_name}")
    #     # find_job_logs_message.deliver!(job.batch_size).fmap do |r|
    #     #   logger.info("Collected #{job.batch_name})
    #     #   handle_fetched_job_logs_message.deliver!(r)
    #     # else
    #     #   logger.error(r)
    #     #   sleep 30
    #     #   schedule_next
    #     # end
    #   end
    # end
    def schedule_next_batch
      job.next_batch
      if job.max_batches_reached?
        logger.info "[Job##{job.name}] Ingestion job is completed"
      else
        fetch_job_logs_message.deliver!(limit: job.batch_size)
        logger.info "[Batch##{job.batch_name}] Scheduled next batch for ingestion job"
      end
    end
  end
end
