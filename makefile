.PHONY: start

PROJECT_PATH:=/Users/serdaroguzhanakin/Documents/EngineGroup

n ?= 10
while:
		n=$(n); \
        while [ $${n} -gt 0 ] ; do \
            echo $$n ; \
            n=`expr $$n - 1`; \
        done; \
        true
yesNo:
	@read  -p "Does kube environment up if not please wait until up (y/n)?: " INPUT; \
    if [ "y" = "$$INPUT" ]; then \
    	echo "let's continue"; \
    fi

yesNoWhile:
		@read  -p "Does kube environment up (y/n)?: " INPUT; \
		if [ "y" = "$$INPUT" ]; then \
			echo "continue? [Y/n]"; \
			read line; \
			echo $$line; \
        else \
			while [ "y" != "$$INPUT2" ] ; do \
					echo "Does kube environment up (y/n)?"; \
					sleep 30; \
					read INPUT2; \
				done; \
				true; \
		fi

		echo "done"

emptyCheck:
		@read  -p "Would you like to run ia-case-documents-api (y/n)?: " INPUT; \
        echo "Your input is " $$INPUT ; \
        if [ -z "$$INPUT" ]; then \
          	echo "Empty"; \
        else \
          	echo "Not empty"; \
        fi

deployDMN:
		 @read  -p "Would you like to deploy DMNs (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
            	echo "Deploying DMNs" \
                sleep 3; \
                osascript \
                    -e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/IA/ia-task-configuration; clear; git clean -d -x -f; git reset --hard; git pull; ./camunda-deployment.sh;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

eventHandler:
			osascript \
                	-e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/WA/wa-case-event-handler; clear; git clean -d -x -f; git reset --hard;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "git pull;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "./gradlew bootRun;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52'

kube:
	@echo "wa-kube-environment starting"
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/WA/wa-kube-environment; clear; git clean -d -x -f; git reset --hard; git checkout master; git pull;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	\
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "$$(source .env);"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	\
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "./environment login"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "./environment pull"' \
	\
	-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "./environment up"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
	\
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd scripts; ./setup.sh"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52'

ccd-definitions:
		@echo "ia-ccd-definitions starting"
		osascript \
		-e 'tell application "iTerm" to activate' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
		-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/IA/ia-ccd-definitions; clear; git clean -d -x -f; git reset --hard; git pull; yarn upload-wa;"' \
		-e 'tell application "System Events" to tell process "iTerm" to key code 52'

start:
	@echo "Environment setup started!!!!"
	az login

	open -a docker

	minikube start --memory=8192 --cpus=4 --driver=hyperkit --addons=ingress

	@echo "$$(minikube ip) ccd-shared-database service-auth-provider-api ccd-user-profile-api shared-db ccd-definition-store-api idam-web-admin ccd-definition-store-api ccd-data-store-api ccd-api-gateway wiremock xui-webapp camunda-local-bpm role-assignment sidam-simulator local-dm-store ccd-case-document-am-api" | sudo tee -a /etc/hosts

	@echo "wa-kube-environment starting"
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/WA/wa-kube-environment;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
    \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "$$(source .env);"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
    \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "./environment login"' \
	-e 'tell application "System Events" to tell process "iTerm" to key code 52' \
    \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "./environment up"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52' \
    \
	-e 'tell application "System Events" to tell process "iTerm" to keystroke "cd scripts; ./setup.sh"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@read  -p "Does kube environment up (y/n)?: " INPUT; \
	if [ "y" = "$$INPUT" ]; then \
		echo "continue? [Y/n]"; \
		read line; \
		echo $$line; \
	else \
	  	sleep 30; \
		while [ "y" != "$$INPUT2" ] ; do \
				echo "Does kube environment up (y/n)?"; \
				sleep 30; \
				read INPUT2; \
			done; \
			true; \
	fi


	@echo "ia-ccd-definitions starting"
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using {command down, shift down}' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/IA/ia-ccd-definitions; git pull; yarn upload-wa;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@echo "ia-case-documents-api starting"
	sleep 3;
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/IA/ia-case-documents-api; git pull; ./gradlew bootRun;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@echo "ia-case-notifications-api starting"
	sleep 3;
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/IA/ia-case-notifications-api; git pull; ./gradlew bootRun;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@echo "ia-case-api starting"
	sleep 3;
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/IA/ia-case-api; git pull; ./gradlew bootRun;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@echo "wa-workflow-api starting"
	sleep 3;
	osascript \
    -e 'tell application "iTerm" to activate' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/WA/wa-workflow-api; git pull; ./gradlew bootRun;"' \
    -e 'tell application "System Events" to tell process "iTerm" to key code 52';

	@read  -p "Would you like to run task-configuration (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
                osascript \
                    -e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/IA/ia-task-configuration; git pull; ./gradlew bootRun;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

	@read  -p "Would you like to run case-event-handler (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
                osascript \
                    -e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/WA/wa-case-event-handler; git pull; ./gradlew bootRun;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

	@read  -p "Would you like to wa-task-management-api (y/n)?: " INPUT; \
            if [ "y" = "$$INPUT" ]; then \
                osascript \
                    -e 'tell application "iTerm" to activate' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "d" using command down' \
                    -e 'tell application "System Events" to tell process "iTerm" to keystroke "cd ${PROJECT_PATH}/WA/wa-task-management-api; clear; git pull; ./gradlew bootRun;"' \
                    -e 'tell application "System Events" to tell process "iTerm" to key code 52'; \
            fi

	@echo "A few minutes later environment will be ready!!!!"